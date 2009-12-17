Return-Path: <linux-kernel-owner+w=401wt.eu-S1764299AbZLQKEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764299AbZLQKEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764273AbZLQKEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:04:44 -0500
Received: from hmcexedge02.ikoula.com ([78.24.135.22]:3319 "EHLO
	mail.hmc.ikoula.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751172AbZLQKEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:04:42 -0500
From: Romain Kubany <rkubany@ikoula.com>
To: Mikael Pettersson <mikpe@it.uu.se>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Thu, 17 Dec 2009 11:04:38 +0100
Subject: RE: Possible regression of LBA48 support for piix
Thread-Topic: Possible regression of LBA48 support for piix
Thread-Index: Acp++1iEjE8IQli7SOi+HnsnWBBRnQAAt3Gw
Message-ID: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2C1@HMCEXMBX01CLUS.hmcikoula.com>
References: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2AF@HMCEXMBX01CLUS.hmcikoula.com>
 <19241.63911.160765.909812@pilspetsen.it.uu.se>
In-Reply-To: <19241.63911.160765.909812@pilspetsen.it.uu.se>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, thanks for the prompt reply and the notice for the cc: :)
I'm using libata and ata_piix now.
My disk is seen as "sda" and a lshw is reporting the controler as using "ata_piix" : 

# lshw -c STORAGE
  *-ide
       description: IDE interface
       product: 82371AB/EB/MB PIIX4 IDE
       vendor: Intel Corporation
       physical id: 7.1
       bus info: pci@0000:00:07.1
       logical name: scsi0
       logical name: scsi1
       version: 01
       width: 32 bits
       clock: 33MHz
       capabilities: ide bus_master emulated
       configuration: driver=ata_piix latency=0

But fdisk always recognize the disk as 136.8Gb :

# fdisk -l

Disk /dev/sda: 136.8 GB, 136899993600 bytes
16 heads, 63 sectors/track, 265260 cylinders
Units = cylinders of 1008 * 512 = 516096 bytes
Disk identifier: 0xd7267427

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1         204      102815+  83  Linux
/dev/sda2             205        2236     1024128   82  Linux swap / Solaris
/dev/sda3            2237       20805     9358776   83  Linux

Here is the new kernel config file : http://pastebin.com/f65fd472b

-----Message d'origine-----
De : linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] De la part de Mikael Pettersson
Envoyé : jeudi 17 décembre 2009 10:28
À : Romain Kubany
Cc : linux-kernel@vger.kernel.org
Objet : Re: Possible regression of LBA48 support for piix

Romain Kubany writes:
 > Hello,
 > 
 > We are using Microsoft Hyper-V Virtualization technology for some of our GNU/Linux guests and we recently discovered 
 > that the emulated hardware does not seem to support LBA48 adressing on IDE controller.
 > 
 > After some tests, here are the results on a VM with a 200GB virtual disk : disk is detected as 214748MB up to kernel 2.6.27.41 and as 136899MB in 2.6.28 and up.
 > 
 > The two kernels (2.6.27.41 and 2.6.28) were compiled with approximatively the same parameters (just an oldconfig between them, I'll paste a line to their respective config at the end of the mail)
 > except that many changes occured in IDE management between 2.6.27 and 2.6.28 series of the kernel so it is possible that the problem is coming from a misconfiguration on our side (in which case I'll present you my truthful apologies for making you waste your time).
 > 
 > Here are some useful informations (I think) for start :
 > 
 > [On the "working" kernel, 2.6.27.41 w/ 200GB recognized vdisk]
 > 
 > # hdparm -I /dev/hda

Try using libata and ata_piix instead of the old IDE drivers, but
be aware that the disk will show up as /dev/sda not /dev/hda.

Also, IDE/ATA-related issues should be cc:d to linux-ide (see MAINTAINERS).
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

