Return-Path: <linux-kernel-owner+w=401wt.eu-S936543AbXGQXCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936543AbXGQXCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936314AbXGQXB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:01:56 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:46730 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934048AbXGQXBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ue7h+RKP9dccBKdPIi0EQDjZuBWB16e6fWaH/uHiQmce+VzXOK9Ac21LkdDURQZUlcA4kPpKLkIHzElDQc4bzjLzFDJQ3pTVWnEGLa8U9E3QglRHUrzL62VMPipCMDVZ+7tFTYfe1BAuh+SavhOwX/jU3OUkwy4d+F4pogsYtA4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Date: Wed, 18 Jul 2007 01:14:56 +0200
User-Agent: KMail/1.9.6
Cc: Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
References: <469D1D5E.8050609@cateee.net> <200707180045.03352.bzolnier@gmail.com> <alpine.LFD.0.999.0707171535170.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707171535170.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180114.56942.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007, Linus Torvalds wrote:
> 
> On Wed, 18 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> > 
> > The new generic SG layer is CONFIG_SCSI=y "generic" in the current tree.
> 
> Yeah. I know, I already talked to Jens about it - in order to be generic, 
> the BSG stuff really does end up having to be able to stand on its own, 
> since not everybody wants/needs the whole SCSI layer.

bsg looks really promising and it would be great if we can use it also
for IDE driver.

> > > obviously the older SCSI-ioctl layer) it should "just work".
> > 
> > Agreed but IDE driver has never claimed to have full SAT layer and
> > full SCSI-ioctl layer support has been provided only for ide-cd.
> 
> I agree, and understand why it happened, but hope that maybe it can be 
> improved in the future, or at least the error returned earlier so that the 
> request will never even hit the ATA device at all if the IDE layer cannot 
> then handle it.

This is _exactly_ how these requests were handled before commit
3d6392cfbd7dc11f23058e3493683afab4ac13a3.

Reverting ide.c chunks is a safe solution for now (no SG_IO and friends
for ide-floppy but this is how it was before this commit).

Thanks,
Bart
