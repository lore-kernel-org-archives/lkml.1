Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbYBNAvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbYBNAvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759563AbYBNAvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:51:07 -0500
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:51478 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703AbYBNAvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:51:05 -0500
Date: Thu, 14 Feb 2008 02:51:47 +0200 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc1
To: Jeff Garzik <jeff@garzik.org>
cc: David Miller <davem@davemloft.net>, chris.mason@oracle.com,
       jengelh@computergmbh.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
In-Reply-To: <47B2517E.3080606@garzik.org>
Message-ID: <Pine.LNX.4.61.0802140145060.4561@dhcppc1>
References: <200802120849.34477.chris.mason@oracle.com>
 <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
 <200802120908.59602.chris.mason@oracle.com> <20080212.153329.98384016.davem@davemloft.net>
 <47B2517E.3080606@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 12 Feb 2008, Jeff Garzik wrote:
> 
> Yep.  I chose 32K unused space in the prototype filesystem I wrote [1, 2.4
> era].  I'm pretty sure I got that number from some other filesystem, maybe
> even some NTFS incarnation.  

NTFS superblock (and the partial mirror copy) can be anywhere except in the 
first blocks. That space is where the $BOOT file is placed which contains 
the bootstrap code and the BIOS Paramether Block which includes the NTFS 
signature and describes various filesystem information needed to locate the 
superblock, etc.

Unlike mkfs.xfs which warns since at least 2002 and requires the -f option 
to override Sun disklabels, at the moment mkfs.ntfs will indeed destroy 
them. 

Thank you for the bug report and let's hope the next generation of Sun 
hardwares won't scatter the firmware too into random places inside a 
partition encoded by a fictitious size of disk cylinder.

	Szaka
