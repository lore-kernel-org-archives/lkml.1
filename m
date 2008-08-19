Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYHSGPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYHSGPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYHSGPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:15:38 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:30502 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYHSGPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:15:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=cicuRXFg2yldmo2lgkPTepdhiHps6qLWuIWOPGanZtapyKgl02jw1t3UFpHwXjcnaM
         le+Lsl+fy75LzTyroObDkwtVjcyqxHRHy0vrSxnNrJMlSTfJ3T2pSPr1fsxk8nHL/h4A
         QbyjW6eZUGjZaHO6BoFF8R8Fyh9UP+jvfftcM=
Date: Tue, 19 Aug 2008 08:15:38 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/5] ide debugging macros
Message-ID: <20080819061538.GA30315@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1218993826-4571-1-git-send-email-petkovbb@gmail.com> <200808182308.38345.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808182308.38345.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 11:08:38PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Sunday 17 August 2008, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here's something i've been wanting to do for a long time: debugging macros. The
> > reason for it is that i got tired of adding debug printk's everytime i'm testing
> > something so here we go.
> > 
> > The debugging macro is similar to the old ones but is one for all drivers
> > (currently only ide-floppy), is nice on branch prediction and is controlled by a
> > drive->debug_mask switch which is a module parameter and as such can be set at
> > module load time, of course. I've been thinking of adding also a sysfs attribute
> > too but can't seem to find quite the justification for it so no sysfs for now :)
> 
> if you look closely you should already find it :)
> 
> [ module parameters are exported through sysfs and it uses 0644 mask ]

Those I saw. (You mean /sys/bus/ide/drivers/ide-cdrom/, for example, right?)
But if so, those come from the gen_driver's ide_bus_type and those are device
attributes and I was thinking of adding ide_bus_type.drv_attrs which are driver-
and not device-specific but since i haven't read into the sysfs code too much
yet this is my hunch what we should do.

> > In addition, one can still optimize away all the debug calls in the old manner
> > and i'm sure those will be removed completely too when ide generic conversion is
> > done.
> > 
> > Please tell me what you think, what can be changed/improved and after we've
> > figured out the details I'll do the other drivers too.
> 
> Looks pretty good to me (after quick look) and I applied to pata tree.
> 
> PS I wonder whether we may also want to have global debug_mask for core code
> messages ('drive' is not always available) in the longer-term.  Or maybe even
> only global debug_mask for both core code and driver messages?

Let me answer you with a question :) : is a u64 bitmask going to be enough for
all the debugging levels, both core and drivers ? The way I see it, hmm, probably ...

-- 
Regards/Gruss,
    Boris.
