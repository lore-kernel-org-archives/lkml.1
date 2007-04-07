Return-Path: <linux-kernel-owner+w=401wt.eu-S965763AbXDGLVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965763AbXDGLVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 07:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965786AbXDGLVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 07:21:49 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:47568 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965763AbXDGLVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 07:21:48 -0400
Date: Sat, 7 Apr 2007 13:21:32 +0200
From: Eduard Bloch <edi@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070407112131.GA10487@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net> <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de> <20070330134327.GA24030@infradead.org> <20070330142114.GA31685@rotes76.wohnheim.uni-kl.de> <20070330191038.067c346b@the-village.bc.nu> <20070331170703.GA8179@rotes76.wohnheim.uni-kl.de> <20070331232002.7b478f37@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070331232002.7b478f37@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

#include <hallo.h>

First, we (me and Thomas Schmidt) are working on a draft for a mandatory
locking scheme which will take care of the most racy situations even
without having a proper in-kernel solution. But you need to exlain some
things, otherwise we cannot rely on your words.

> (open has side effects relocking doesnt)

What exactly does that mean in our scope?

Can we do following without having side effects:

open("/dev/sr0",O_EXCL|O_RDWR); /* no matter what it returns */
fcntl(..., F_SETLK); /* no matter what it returns */
ioctl(f, SCSI_IOCTL_GET_IDLUN, &x);
ioctl(f, SCSI_IOCTL_GET_BUS_NUMBER, &jo);

Can you guarantee us that bit? 

Or shall we really implement ugly workarounds to avoid every open call?
Note that "just do like UUCP guys" is not as easy or reliable as people
may pretend.

Eduard.

-- 
Naja, Garbage Collector eben. Holt den Müll sogar vom Himmel.
       (Heise Trollforum über Java in der Flugzeugsteuerung)
