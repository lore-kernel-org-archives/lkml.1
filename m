Return-Path: <linux-kernel-owner+w=401wt.eu-S1031193AbXDZPu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031193AbXDZPu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031287AbXDZPuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:50:25 -0400
Received: from brick.kernel.dk ([80.160.20.94]:7484 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031193AbXDZPuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:50:25 -0400
Date: Thu, 26 Apr 2007 17:46:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan.Brunelle@pobox.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/15] cfq-iosched: speed up rbtree handling
Message-ID: <20070426154643.GB2017@kernel.dk>
References: <11774025432481-git-send-email-jens.axboe@oracle.com> <11774025432403-git-send-email-jens.axboe@oracle.com> <462F7AD9.8020300@hp.com> <20070425171539.GE4730@kernel.dk> <20070425175047.GF4730@kernel.dk> <20070425180813.GI4730@kernel.dk> <4630B70D.7070409@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630B70D.7070409@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26 2007, Alan D. Brunelle wrote:
> Jens Axboe wrote:
> >On Wed, Apr 25 2007, Jens Axboe wrote:
> >>On Wed, Apr 25 2007, Jens Axboe wrote:
> >>>On Wed, Apr 25 2007, Alan D. Brunelle wrote:
> >>>>Hi Jens -
> >>>>
> >>>>The attached patch speeds it up even more - I'm finding a >9% reduction 
> >>>>in %system with no loss in IO performance. This just sets the cached 
> >>>>element when the first is looked for.
> >>>Interesting, good thinking. It should not change the IO pattern, as the
> >>>end result should be the same. Thanks Alan, will commit!
> >>>
> >>>I'll give elevator.c the same treatment, should be even more beneficial.
> >>>Stay tuned for a test patch.
> >>Something like this, totally untested (it compiles). I initially wanted
> >>to fold the cfq addon into the elevator.h provided implementation, but
> >>that requires more extensive changes. Given how little code it is, I
> >>think I'll keep them seperate.
> >
> >Booted, seems to work fine for me. In a null ended IO test, I get about
> >a 1-2% speedup for a single queue of depth 64 using libaio. So it's
> >definitely worth it, will commit.
> >
> After longer runs last night, I think the patched elevator code /does/ 
> help (albeit ever so slightly - about 0.6% performance improvement at a 
> 1.1% %system overhead).
> 
>  rkB_s    %system  Kernel
> ---------  -------  ----------------------------------------------------
> 1022942.2     3.69  Original patch + fix to cfq_rb_first
> 1029087.0     3.73  This patch stream (including fixes to elevator code)

Ah good, thanks for testing! It's all in the cfq branch now.

-- 
Jens Axboe

