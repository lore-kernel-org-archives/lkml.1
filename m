Return-Path: <linux-kernel-owner+w=401wt.eu-S935420AbZLQNfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935420AbZLQNfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764760AbZLQNfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:35:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53171 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764747AbZLQNfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:35:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=XAxcIoTe9miqZEXed+Hm+z7DatjnRiI6/1uAhNcgYKY9qh6z1QIkRx6jNKEob5utTu
         Qih48nq+VYQYY1Mjq4E6UZHM8uIn5bF51U2OOtxtoOwpsCoaAFQxp8wZ2jzklKAuPfYb
         IalHpb5mY6Pd7iH0uw5Jk3MTAnQmloQcIePSk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: Possible regression of LBA48 support for piix
Date: Thu, 17 Dec 2009 14:33:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Romain Kubany <rkubany@ikoula.com>, Mikael Pettersson <mikpe@it.uu.se>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
References: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2AF@HMCEXMBX01CLUS.hmcikoula.com> <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB31D@HMCEXMBX01CLUS.hmcikoula.com> <4B2A227E.2010106@garzik.org>
In-Reply-To: <4B2A227E.2010106@garzik.org>
MIME-Version: 1.0
Message-Id: <200912171433.39135.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 December 2009 01:22:22 pm Jeff Garzik wrote:
> On 12/17/2009 07:07 AM, Romain Kubany wrote:
> > Here it is under the 2.6.28 :
> >
> > # hdparm -I /dev/sda
> >
> > /dev/sda:
> >
> > ATA device, with non-removable media
> >          Model Number:       Virtual HD
> >          Serial Number:
> >          Firmware Revision:  1.1.0
> > Standards:
> >          Likely used: 2
> > Configuration:
> >          Logical         max     current
> >          cylinders       16383   65535
> >          heads           16      16
> >          sectors/track   63      255
> >          --
> >          bytes/track: 65024      bytes/sector: 512
> >          CHS current addressable sectors:  267382800
> >          LBA    user addressable sectors:  267382800
> >          device size with M = 1024*1024:      130558 MBytes
> >          device size with M = 1000*1000:      136899 MBytes (136 GB)
> 
> Yeah, that info is straight from the virtual disk, without any sort of 
> massaging.  The disk is reporting 136GB max, so I would poke around 
> Windows to see if a setting changed somewhere...  maybe there is an "old 
> IDE compatible" setting that got turned on, for the virtual hd?

It is also possible that this virtual disk has never worked with ata_piix
driver and worked with piix driver in the older kernels because of pure luck.

In 2.6.28 I've fixed LBA48 checks in IDE to match libata (see commit 942dcd8
for details) so it would be worth to try:

	- simulating the older buggy IDE behavior with 2.6.32 kernel

or

	- staring long enough at 'hdparm --Istdout /dev/sda' output

first.

--
Bartlomiej Zolnierkiewicz
