Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbXHZKLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbXHZKLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 06:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbXHZKLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 06:11:10 -0400
Received: from mx1.of.net-lab.net ([80.69.37.105]:53278 "EHLO
	imap.internetcave.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbXHZKLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 06:11:08 -0400
Message-ID: <46D151B9.4070605@aj.net-lab.net>
Date: Sun, 26 Aug 2007 12:11:05 +0200
From: Andreas John <lists@aj.net-lab.net>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: stellplatz-nr.13a@datenparkplatz.de, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>	 <45F7E7E9.6010703@gmail.com>	 <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>	 <45F93888.1080207@gmail.com> <5767b9100703270253j2ac3b543y499323b42c6402b@mail.gmail.com> <46CCA483.4080105@aj.net-lab.net> <46CCB23E.1000506@aj.net-lab.net> <46CD692D.3070508@aj.net-lab.net>
In-Reply-To: <46CD692D.3070508@aj.net-lab.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hm,
it seems we are victim of a SATA NCQ HORKAGE:
http://www.mail-archive.com/linux-ide@vger.kernel.org/msg08936.html

Disableing NCQ seems to work on the sb600. Samsung already ships a newer
edition ("403" instead of "401")  but there is no fix for the NCQ  in
the 401 edition. With Samsungs HUTIL you cannot disbale NCQ on the disk
itself. Sadly we have about 20 pcs SAMSUNG HD401LJ of the broken one here :/

Interstingly the ncq horkage does not affect the platforms which are
ICH7-based. We replugged both harddisks to some core2quad/ICH7-based
system without any change in software - and it works without lockups. Is
that simply luck? According to dmesg NCQ is activated on the ICH7.
Is it currently only possible to ATA_HORKAGE_NONCQ generally? Or can
that be done per chipset?

Best Regards,
Andreas

@Ulrich: On what kind of chipset did you observe the horkage?

Andreas John schrieb:
> Hi,
> as requested by Tejun here comes dmesg and lspci -nn. Additionally I
> found something dmesg (See 1.), probably caused by the low-level error.
> 
> Best Regards,
> Andreas
> 
> 1.)
> [81739.060000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK,SUGGEST_OK
> [81739.060000] end_request: I/O error, dev sdb, sector 0
> 
> 2.) lspci -nn
> root@derjohn-host:~# lspci -nn
> 00:00.0 Host bridge [0600]: ATI Technologies Inc Unknown device [1002:7910]
> 00:01.0 PCI bridge [0604]: ATI Technologies Inc Unknown device [1002:7912]
> 00:12.0 SATA controller [0106]: ATI Technologies Inc SB600 Non-Raid-5
> SATA [1002:4380]
> 00:13.0 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI0)
> [1002:4387]
> 00:13.1 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI1)
[SNIP]
