Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYBMNRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYBMNRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYBMNRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:17:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:54164 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYBMNRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:17:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=WE+ynR43CpGIFr1y1cqBRamZ8SzaiH3yWPw3PRbKoEzcBFc4llCmoyf4WBCiKrt50/GXMEugHaJT4lpLeiywall5F1JGTQwIgo2Ho1fS9d3gbv6KNUW96gnr/+/l6/NGVMSyDFrdf1Gs6t9iPsmzaDg8xQWxfET/dRdaMz6Z7SM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [RFC PATCH] ide-floppy: use rq->cmd for preparing and sending packet cmds to the drive
Date: Wed, 13 Feb 2008 14:30:16 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080212143715.GB4530@gollum.tnic> <200802122239.22566.bzolnier@gmail.com> <20080213124625.GB13446@gollum.tnic>
In-Reply-To: <20080213124625.GB13446@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802131430.16450.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 13 February 2008, Borislav Petkov wrote:
> On Tue, Feb 12, 2008 at 10:39:22PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi Bart,
> 
> > I think that this _really_ should be done _after_ unifying ATAPI handling [*].
> > Otherwise you will be making some of the same changes to the _three_ copies
> > of (more or less) identical code and more importantly we will have to delay
> > unification after _all_ drivers are converted to rq->cmd[] (+ lets not forget
> > that I'll have more changes to review ;).
> > 
> > (*) please take a closer look at *_issue_pc(), *_transfer_pc() and *_pc_intr()
> >     in ide-{floppy,tape,scsi} (the useful hint is that after making these
> >     functions free of references to device driver specific objects/functions
> >     we can use drive->media == ide_{floppy,tape,scsi} checks for handling
> >     not yet fully unified / media type specific code).
> 
> I started working on probably the easiest unification we could do: unify all the
> pc->flags defines and move them in a header where all drivers can use them. This

Yep.

> raises an architectural design question: The way i see it, the generic ATAPI handling
> is going to be sort of "serving" functionality to the drivers using ATAPI. Do we want
> all this functionality to go to ide.{h,c} or we want specific atapi.{h,c} files that
> contain only this unified functionality, or whatever else. In general, how is this
> generic layer going to be distributed among headers/.c files and what do we want there?
> 
> /me tends to think that special headers/files, small and easy to manage and
> modular, have more advantages in this case but this is just me. After we've
> decided on that, the rest of the issues will resolve by themselves/get easier to
> tackle.

I think that:

	drivers/ide/ide-atapi.c
	include/linux/ide.h

should be fine for now...

Moving code around is trivial so we can always fixup before pushing upstream.

Thanks,
Bart
