Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYCRLIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYCRLIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYCRLIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:08:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15519 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYCRLII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:08:08 -0400
Date: Tue, 18 Mar 2008 12:08:04 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: petkovbb@gmail.com
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ide_cd modifies hard_* members of request
Message-ID: <20080318110803.GV17940@kernel.dk>
References: <1205830486.7126.16.camel@nikanth-laptop.blr.novell.com> <9ea470500803180405h5ede15eaqa86515058a632e2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea470500803180405h5ede15eaqa86515058a632e2b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18 2008, Boris Petkov wrote:
> (sorry, forgot to cc all)
> 
> On Tue, Mar 18, 2008 at 9:54 AM, Nikanth Karthikesan <knikanth@suse.de> wrote:
> > Hi
> >
> >  Despite the warning in blkdev.h, that members of struct request starting
> >  with hard_* are block layer internals, and no driver should touch them,
> >  the ide_cd driver seems to fiddle around with it.
> >
> >  Is this reqd, or can this be made to work without the need for this?
> >
> >  If this reqd, why not provide a helper function for that in block layer
> >  itself, may be, with a warning about usage?
> >
> >  Thanks
> >  Nikanth Karthikesan
> 
> Hi,
> 
> the code pieces you're referring to are in there since at least the
> first git import of the kernel source (i.e. 2005) aka long time so
> Bart/Jens should know that...

restore_request(), I'm assuming. It was probably me who modified this
code, I don't think there's any justification for it. I would suggest
killing it. And cdrom_read_from_buffer() as well, it's a silly addition.

-- 
Jens Axboe

