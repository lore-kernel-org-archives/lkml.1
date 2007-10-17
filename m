Return-Path: <linux-kernel-owner+w=401wt.eu-S1759171AbXJQGio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbXJQGio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbXJQGig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:38:36 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35364 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754210AbXJQGig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:38:36 -0400
Date: Wed, 17 Oct 2007 08:38:34 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: ioctl32: Unknown cmd
In-Reply-To: <200710162150.37636.arnd@arndb.de>
Message-ID: <Pine.LNX.4.62.0710170837490.7197@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0710161642200.20196@pademelon.sonytel.be>
 <200710162150.37636.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-826465017-1192603114=:7197"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-826465017-1192603114=:7197
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 16 Oct 2007, Arnd Bergmann wrote:
> On Tuesday 16 October 2007, Geert Uytterhoeven wrote:
> > The recent (post 2.6.23) changes to compat_ioctl made the reporting of
> > unsupported ioctls more verbose. E.g. on the PS3 I get:
> > 
> > | ioctl32(cdrom_id:608): Unknown cmd fd(3) cmd(00005331){t:'S';sz:0} arg(00000000) on /dev/.tmp-11-0
> > | ioctl32(hdparm:1427): Unknown cmd fd(3) cmd(0000031f){t:03;sz:0} arg(00000000) on /dev/ps3da
> > | ioctl32(hdparm:1427): Unknown cmd fd(3) cmd(0000031f){t:03;sz:0} arg(00000000) on /dev/ps3da
> > 
> > The first one is triggered by the detection of the CD/DVD/BD-ROM driver,
> > The others are triggered by me running hdparm.
> > 
> > Was this intentional?
> 
> No, it was certainly not intentional, and I can't figure out why it happens.
> The ioctl numbers from your example are HDIO_DRIVE_CMD and CDROM_GET_CAPABILITY,
> both of which should be handled through compat_blkdev_driver_ioctl by calling
> the native ioctl method of the driver, and return -ENOTTY otherwise.
> 
> The one point where it is expected to have changed now is when you try
> to do these ioctls on something that is not a block device. Are you sure that
> the files you tried them on were created correctly?

/dev/ps3da is definitely a block device.

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-826465017-1192603114=:7197--
