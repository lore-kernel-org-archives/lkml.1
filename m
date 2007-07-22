Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXGVWMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXGVWMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbXGVWMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:12:31 -0400
Received: from keil-draco.com ([216.193.185.50]:50072 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbXGVWMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:12:30 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Bartek <poemann@gmail.com>
Subject: Re: Pata support for IDE Controller 82801G ICH7 in Linux 2.6.22
Date: Sun, 22 Jul 2007 18:12:17 -0400
User-Agent: KMail/1.9.6
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <19061b0b0707220259h207f27d7wa836b1973c547e63@mail.gmail.com> <20070722213844.6a1656c3@the-village.bc.nu> <19061b0b0707221503mc18ae4ese658748a1f499e5c@mail.gmail.com>
In-Reply-To: <19061b0b0707221503mc18ae4ese658748a1f499e5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707221812.18286.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 18:03:06 Bartek wrote:
> 2007/7/22, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > > > 00:1f.1 0101: 8086:27df (rev 02)
> > >
> > > Ok, this controller is supported.
> > > Did you forgot about CONFIG_PATA_MPIIX=y?
> >
> > MPIIX is for early Intel laptop (pentium era).
> >
> > If the chip is in AHCI mode then CONFIG_AHCI may be what is missing
>
> I made a few tests. First I booted my comp with Ubuntu Live Feisty
> Fawn, checked modules which are loaded, and interesting ones are:
> ata_piix, ata_generic, libata, scsi_mod, sg, sr_mod, sd_mod
> ls /dev/sda* showed:
> /dev/sda{1,2,3,4}.
> So I recompiled the kernel with these options (marking all these
> drivers as a modules, in the previous situation they were modules, as
> well as compiled directly), and tried to boot. Nothing worked. The
> same situation appeared: Waiting for root file system...
> Second, I installed a Debian distribution kernel
> (linux-image-2.6.22-1-686) and booted from it. It used an old IDE
> driver, not PATA. So again no success.
> According to AHCI, my chip is rather not that kind. Ubuntu does not
> load any AHCI modul. In my previous kernel compilations I tried that
> option as well. It did not work.

This sounds like a problem I ran into when I tried to boot a 2.6.21 kernel 
using libata with Ubuntu Edgy installed. The init script on the initramfs 
failed at the same point - not a problem with the drivers, but a problem with 
what the scripts are looking for. I'd suggest looking at the scripts on the 
initramfs - its been my experience that they are the culprit and not the 
kernel itself.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
