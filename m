Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZASXg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZASXg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZASXgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:36:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbZASXgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:36:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.29-rc2: thinkpad dock -- cdrom vs. s2ram
Date: Tue, 20 Jan 2009 00:36:14 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com,
       trenn@suse.de, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
References: <20090119202423.GA7070@ucw.cz> <200901192150.59438.rjw@sisk.pl> <20090119221508.GA2576@elf.ucw.cz>
In-Reply-To: <20090119221508.GA2576@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901200036.14640.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Pavel Machek wrote:
> On Mon 2009-01-19 21:50:58, Rafael J. Wysocki wrote:
> > On Monday 19 January 2009, Pavel Machek wrote:
> > > Hi!
> > > 
> > > In 2.6.29 (and probably earlier) kernels, booting in docking station
> > > results in undocked s2ram failing.
> > > 
> > > Problem seems to be that hda (cdrom in dock) is not deregistered
> > > during undock, and that hda driver loops spitting error messages at
> > > 'too-fast-to-read' rate when suspend with missing hda is attempted.
> > 
> > What driver do you mean exactly?  Old-IDE I would guess.
> > 
> > Does this also happen with a PATA/libata driver?
> 
> I guess I'm confused. I tried:
> 
> --- config.ok	2009-01-19 11:40:42.000000000 +0100
> +++ ../b-linux/.config	2009-01-19 22:45:03.000000000 +0100
> @@ -1022,7 +1022,7 @@
>  # CONFIG_SATA_SIL24 is not set
>  CONFIG_ATA_SFF=y
>  CONFIG_SATA_SVW=y
> -CONFIG_ATA_PIIX=y
> +# CONFIG_ATA_PIIX is not set
>  # CONFIG_SATA_MV is not set
>  # CONFIG_SATA_NV is not set
>  # CONFIG_PDC_ADMA is not set
> @@ -1058,8 +1058,8 @@
>  # CONFIG_PATA_JMICRON is not set
>  # CONFIG_PATA_TRIFLEX is not set
>  # CONFIG_PATA_MARVELL is not set
> -# CONFIG_PATA_MPIIX is not set
> -# CONFIG_PATA_OLDPIIX is not set
> +CONFIG_PATA_MPIIX=y
> +CONFIG_PATA_OLDPIIX=y
>  # CONFIG_PATA_NETCELL is not set
>  # CONFIG_PATA_NINJA32 is not set
>  # CONFIG_PATA_NS87410 is not set
> 
> ...but cdrom is still detected as hda.

Er, CONFIG_ATA_PIIX is a SATA driver.  I think you need to disable
CONFIG_BLK_DEV_PIIX and perhaps CONFIG_IDE_GENERIC too.

Rafael
