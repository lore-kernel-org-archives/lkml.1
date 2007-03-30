Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbXC3OVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbXC3OVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 10:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXC3OVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 10:21:25 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:43002 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbXC3OVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 10:21:24 -0400
Date: Fri, 30 Mar 2007 16:21:14 +0200
From: Eduard Bloch <edi@gmx.de>
To: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070330142114.GA31685@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net> <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de> <20070330134327.GA24030@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330134327.GA24030@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

#include <hallo.h>
* Christoph Hellwig [Fri, Mar 30 2007, 02:43:27PM]:

> > Long story:
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=413960
> > https://bugzilla.novell.com/show_bug.cgi?id=226019
> > http://lists.alioth.debian.org/pipermail/debburn-devel/2007-February/000297.html
> > and other error messages.
> > 
> > There is AFAICS no simple way to establish locking across the driver
> > borders. If kernel developers have a good idea, any help is appreciated.
> > 
> > Below are the typical symptoms: wodim operates via /dev/sgX because the
> > user chosen it this way, some other process (most likely hald) comes
> > along and reads from /dev/sr0 and the drive gets confused. Boom.
> 
> You have thre problems here, and none of them are in the kernel :)
> 
> First the hardsware is broken when it can't deal with concurrent requests,
> I'd try to get a refund for it.  Second wodim should never ever use
> /dev/sg if the sr node is available.  And third HAL should stop poking
> devices all the time.  Then again hald is a totally lost cause and
> I can only recommend to uninstall it ASAP.

Then make /dev/sg* unusable when something opens /dev/sr. Please.
Otherwise it is just another assumption of how things might or should
work, not really matching the use cases in the wild. And here are
some real world facts:

 - there is a fixed mapping between the fake-SCSI numbers and devices
   established by Schilling. People are using it, it is hardcoded into
   frontend applications. We cannot change that overnight without
   breaking even more stuff.
   
   If there is a simple way to get the mapping between the sg and sr
   devices that would be great and almost solve the problems, but I
   cannot discover a such thing in the kernel.

 - hald is using O_EXCL already, as wodim does, and this seems to work
   well as long as they are acting on the same virtual devices.

 - hald is installed together with KDE. Do you suggest to remove KDE as
   well? I don't think so.

 - of course the hardware does not handle concurent requests, it is
   designed that way. It is burden of kernel to canalize the access and
   deal with concurrency issues. Obviously the kernel can and shall not
   do all the work but at least the basic safety mechanisms must work
   reliably and currently they don't.

Eduard.
-- 
<LGS> Halloechen, ihr Spinner, so frueh auf?
<nusse> nein, wir schlafen alle im kollektiv
<knorke> mein alkoven ist kaputt
<teq> alkohol kaputt?
