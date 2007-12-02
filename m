Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbXLBQnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbXLBQnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbXLBQnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:43:39 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:50533 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbXLBQni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:43:38 -0500
Date: Sun, 2 Dec 2007 18:43:33 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Dan Kegel <dank@kegel.com>,
       Xavier Bestel <xavier.bestel@free.fr>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: Relax permissions for reading hard drive serial number?
Message-ID: <20071202164333.GJ6372@mea-ext.zmailer.org>
References: <a71bd89a0711290713w809db6fv933ee9d9744bab6c@mail.gmail.com> <a71bd89a0711290746q57002217ga14c4f4f7201683d@mail.gmail.com> <3ae72650711290939w4fee581fm6f0d65a33abf1b82@mail.gmail.com> <200711292207.46967.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711292207.46967.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 10:07:46PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > There are people who, for privacy reasons, really don't like that "unique"
> > unchangeable serial numbers can be retrieved by untrusted users.
> > 
> > You should probably chmod the file on the users system, if he is fine with
> > that, but not change the kernel default.
> 
> Seconded.
> 
> While on it, how's about exporting model/firmware/serial through
> sysfs so /proc/ide/hd*/identify don't have to be used?


Nice, except that while my home workstation running 2.6.23 kernel
does have 4 SATA disks in it, plus a compact flash memory card on
PATA (boot device, while SATA-disks are JBOD in SW RAID), it has
_no_  /sys/bus/ide/,  nor  /proc/ide/
All devices are under /sys/bus/scsi/

Simplest way for me to pick this data is to use  "hdparm -I /dev/sdX"
command.  Which of course must be run as root.  All it does is to open
named device, and issue one ioctl().

That ioctl() can be embedded into a suid-root helper program, or it
can even (in case of Wine) be run separately to write a text file
storing these identifier data on some Wine config file, which the
"read from physical device X" then does receive.

In my case I don't want to report any of the hard-drive serial numbers,
but rather my boot-device - a flash drive.  Hard-drives do break at
some point in time, a flash drive in read-only mode does last considerably
longer.

> [PATCH] ide: add /sys/bus/ide/devices/*/{model,firmware,serial} sysfs entries
...

/Matti Aarnio
