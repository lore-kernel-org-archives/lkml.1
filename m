Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYC3TAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYC3TAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYC3S7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 14:59:50 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3778 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752349AbYC3S7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 14:59:50 -0400
Date: Sun, 30 Mar 2008 14:59:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Sergey Dolgov <solkaa@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
In-Reply-To: <20080330074927.GA8178@slk.laptop>
Message-ID: <Pine.LNX.4.44L0.0803301456560.21506-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008, Sergey Dolgov wrote:

> Hi!
> 
> If I boot Asus Eee PC with 8 Gb Transcend SDHC card inserted into the
> internal card reader, 2.6.25-rc7 prints the following:
> 
>    [    9.914968] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
>    [   10.248951] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors (8018 MB)
>    [   10.249695] sd 2:0:0:0: [sdb] Write Protect is off
>    [   10.249928] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
>    [   10.249935] sd 2:0:0:0: [sdb] Assuming drive cache: write through
>    [   10.256632] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors (8018 MB)
>    [   10.257440] sd 2:0:0:0: [sdb] Write Protect is off
>    [   10.257546] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
>    [   10.257552] sd 2:0:0:0: [sdb] Assuming drive cache: write through
>    [   10.257657]  sdb: sdb1 sdb2 sdb3
>    [   10.259560] sd 2:0:0:0: [sdb] Attached SCSI removable disk
>    [   10.260489] usb-storage: device scan complete
>    [   10.380590] sd 2:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
>    [   10.380590] sd 2:0:0:0: [sdb] Sense Key : 0x4 [current] 
>    [   10.380590] sd 2:0:0:0: [sdb] ASC=0x11 ASCQ=0x0
>    [   10.380590] end_request: I/O error, dev sdb, sector 15660024
> 
> As a result, no sdb device is created by udev.
> 
> If the card is inserted after the boot, it sometimes works fine (I've
> tested with "dd if=/dev/sdb of=/dev/null bs=512 skip=15660000"), and
> sometimes fails in the same way (the same I/O error message, dd
> hangs).
> 
> 2.6.24.4 is fine (no problems at boot, always can dd read the whole
> card, all 15660032 sectors of it).
> 
> The other SD card I've got, 2 Gb, also works ok even with 2.6.25-rc7.

Can you build both 2.6.24.4 and 2.6.25-rc7 with
CONFIG_USB_STORAGE_DEBUG enabled, and post the dmesg logs from both
kernels showing what happens when the SDHC card is probed during boot?
Comparing the two logs should indicate where the crucial difference 
lies.

Alan Stern

