Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXDKKNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXDKKNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXDKKNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:13:44 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:41458 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXDKKNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:13:43 -0400
Date: Wed, 11 Apr 2007 12:12:45 +0200
From: Eduard Bloch <edi@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org,
       Jens Axboe <axboe@suse.de>
Subject: Re: broken device locking, sg vs. sg_io on block devices
Message-ID: <20070411101245.GA32592@rotes76.wohnheim.uni-kl.de>
References: <200703261811.21448.gerald@itzgrund.net> <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de> <20070330134327.GA24030@infradead.org> <20070330142114.GA31685@rotes76.wohnheim.uni-kl.de> <20070330191038.067c346b@the-village.bc.nu> <20070331170703.GA8179@rotes76.wohnheim.uni-kl.de> <20070331232002.7b478f37@the-village.bc.nu> <20070407112131.GA10487@rotes76.wohnheim.uni-kl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070407112131.GA10487@rotes76.wohnheim.uni-kl.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

#include <hallo.h>
* Eduard Bloch [Sat, Apr 07 2007, 01:21:31PM]:

> Can we do following without having side effects:
> 
> open("/dev/sr0",O_EXCL|O_RDWR); /* no matter what it returns */
> fcntl(..., F_SETLK); /* no matter what it returns */
> ioctl(f, SCSI_IOCTL_GET_IDLUN, &x);
> ioctl(f, SCSI_IOCTL_GET_BUS_NUMBER, &jo);
> 
> Can you guarantee us that bit? 
> 
> Or shall we really implement ugly workarounds to avoid every open call?
> Note that "just do like UUCP guys" is not as easy or reliable as people
> may pretend.

Excuse me, but is there ANYBODY willing to give a binding statement on
that? First you tell "us CD writing guys" to manage that in user space
[1] and when we get real critical questions then everything we get is
radio silence? Very kindly. NOT.

Background: there are two good ways we can go:

a) carefully collecting device properties, mapping and opening
   additional devices
b) additional lockfiles delegating the locking operations

Unfortunately b leads to major problems in practice, while a looks
more promising but need a guarantee that it will be kept be working and
harmless in the future kernel releases. We need to know that before
moving on to missionary work.

Regards,
Eduard.

[1] which IMO still sucks because it's allowed to have device driver
access from any file, thus dealing locking problems at file level is
like fighting a hydra. And with multiple semi-autonomous drivers for the
same hardware even the previous silver bullet (O_EXCL) does not help.

-- 
Ich bin bereit überall hinzugehen, wenn es nur vorwärts ist.
		-- David Livingstone
