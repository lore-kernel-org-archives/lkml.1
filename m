Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbYBMMrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbYBMMrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYBMMq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:46:57 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:6761 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYBMMq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:46:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=Seq489VYa6f2kt9KiuPsf4HIDUQgwy11BL2YFHqVASW89WXGZYXab3357QzaUEflJb5sCquvM6uxCsCrz8VEt9A2UYI4xGSRFPCyyNBvZbuSjvUKtLBAWBw2N2hof+uPs1aCtN3Z+Q4117C+BNRbxE5BdCnp6YeKJ2/GcGOShQk=
Date: Wed, 13 Feb 2008 13:46:25 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [RFC PATCH] ide-floppy: use rq->cmd for preparing and sending
	packet cmds to the drive
Message-ID: <20080213124625.GB13446@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080212143715.GB4530@gollum.tnic> <200802122239.22566.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802122239.22566.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:39:22PM +0100, Bartlomiej Zolnierkiewicz wrote:

Hi Bart,

> I think that this _really_ should be done _after_ unifying ATAPI handling [*].
> Otherwise you will be making some of the same changes to the _three_ copies
> of (more or less) identical code and more importantly we will have to delay
> unification after _all_ drivers are converted to rq->cmd[] (+ lets not forget
> that I'll have more changes to review ;).
> 
> (*) please take a closer look at *_issue_pc(), *_transfer_pc() and *_pc_intr()
>     in ide-{floppy,tape,scsi} (the useful hint is that after making these
>     functions free of references to device driver specific objects/functions
>     we can use drive->media == ide_{floppy,tape,scsi} checks for handling
>     not yet fully unified / media type specific code).

I started working on probably the easiest unification we could do: unify all the
pc->flags defines and move them in a header where all drivers can use them. This
raises an architectural design question: The way i see it, the generic ATAPI handling
is going to be sort of "serving" functionality to the drivers using ATAPI. Do we want
all this functionality to go to ide.{h,c} or we want specific atapi.{h,c} files that
contain only this unified functionality, or whatever else. In general, how is this
generic layer going to be distributed among headers/.c files and what do we want there?

/me tends to think that special headers/files, small and easy to manage and
modular, have more advantages in this case but this is just me. After we've
decided on that, the rest of the issues will resolve by themselves/get easier to
tackle.

Thanks.

-- 
Regards/Gruﬂ,
    Boris.
