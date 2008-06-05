Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYFEHDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYFEHDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 03:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYFEHD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 03:03:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23299 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbYFEHD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 03:03:27 -0400
Date: Thu, 5 Jun 2008 09:03:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tristan Linnenbank <tristan@byte.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: file_splice_read problem in 2.6.24.2?
Message-ID: <20080605070324.GB5757@kernel.dk>
References: <4846AB26.5040802@byte.nl> <20080604163559.GS5757@kernel.dk> <48478EB5.9020207@byte.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48478EB5.9020207@byte.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05 2008, Tristan Linnenbank wrote:
> Jens Axboe wrote:
> >So either this is fixed by this:
> >
> >http://git.kernel.dk/?p=linux-2.6.git;a=commit;h=8191ecd1d14c6914c660dfa007154860a7908857
> >
> >or it's a different bug. You should post the full oops (including any
> >message that came before the oops, like the 'locked up for foo seconds'
> >in the urls you reference above) with the Code line at the bottom as
> >well so we can see what the registers are used for.
> >
> >If it's the bug fixed with the above commit, then 2.6.25.x should
> >work. Unfortunately I'm unsure of the -stable status of the above
> >patch.
> >
> thanks for your reply.
> 
> I appended five of the bunch of errors to this mail. They all lock the 
> CPU for 11 seconds (just like the nfsd errors we had in February/April), 
> so that could be a sign of them being the same bug.
> 
> It seems to be the same problem. We've only seen this behaviour once on 
> the one machine though. I'll keep a couple of webservers on 2.6.24.2 and 
> some on 2.6.25.4, just to see what happens.
> 
> Thanks!
> 
> Kind regards,
> 
> Tristan
> 
> Jun  4 15:08:38 web10.c1.internal kernel: BUG: soft lockup - CPU#0 stuck 
> for 11s! [apache2:22361]

Yep, that looks like the same 'spinning in splice read' problem, so
the 2.6.25 kernel should work fine.

-- 
Jens Axboe

