Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbZH1HGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbZH1HGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZH1HGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:06:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57081 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZH1HGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:06:40 -0400
Date: Fri, 28 Aug 2009 09:06:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, jeff@garzik.org, dhowells@redhat.com
Subject: Re: [PATCH 0/3] Convert libata pio task to slow-work
Message-ID: <20090828070641.GR12579@kernel.dk>
References: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com> <4A967DD7.20603@kernel.org> <20090827124927.GJ12579@kernel.dk> <4A96830F.9040805@kernel.org> <20090827184939.GK12579@kernel.dk> <4A9780EF.1030102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9780EF.1030102@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28 2009, Tejun Heo wrote:
> >>> Care to post it? I know you don't think it's perfect yet, but it would
> >>> make a lot more sense to throw effort into this rather than waste time
> >>> on partial solutions.
> >> I have this printed out code with full of red markings from proof
> >> reading and flush implementation is mostly broken.  Please give me a
> >> couple of days.  I'll post a rough unsplit version which at least
> >> compiles with the planned changes applied by the end of the week.  :-)
> > 
> > Alright, fair enough.
> > 
> > One question - do the 'exposed' workqueues (the ones that drivers
> > allocate/create) sitting in front of the global cpu queue allow more
> > than one thread per cpu, or is that property retained for the global cpu
> > queue (where it is a necessity)?
> 
> The exposed workqueues basically just play the gateway and don't have
> threads associated with it, well, at least not the normal ones.  It
> may have single dedicated thread which usually isn't used but only
> gets summoned when a queue stall is detected (new thread needs to be
> created but blocks on allocation kind of situation).  So, only the
> global cpu queue has normal workers and there are multiple per cpu and
> they're shared by all exported workqueues.

Thanks for the clarification, it answers the question on what level of
functionality is observed by the exported workqueues. Sounds good!

-- 
Jens Axboe

