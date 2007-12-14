Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbXLNFcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbXLNFcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 00:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXLNFcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 00:32:43 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:28083 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbXLNFcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 00:32:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H3inT2u4kQU68sjEF77Yi2jV9bIetBPSSenaAbxn2FJn3P+Z5fQsYM67h74dPeQdBFRMJgPuCpFhSuKDzoz8b5vqxPOd18tLIn3Ls8LUYqH6XG4GqxjoS4ifN//GJHbosKb5ZLNMh3Dp68HmUlhMNvxPmqvdHxYA6d0kfHPIwoc=
Message-ID: <a8e1da0712132132t6bcef833vc492e4164c22705a@mail.gmail.com>
Date: Fri, 14 Dec 2007 13:32:40 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc5-mm1
Cc: linux-kernel@vger.kernel.org, mdharm-usb@one-eyed-alien.net,
       gregkh@suse.de, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
In-Reply-To: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The behaviour of my mp3 player (also act as usb-storage device) seems
changed from rc5 to rc5-mm1.

<dmesg output under rc5>:
=========
usb 1-7: new high speed USB device using ehci_hcd and address 7
usb 1-7: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 7
usb-storage: waiting for device to settle before scanning
scsi 4:0:0:0: Direct-Access                   Newman mp3       PQ: 0 ANSI: 0 CCS
sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
sd 4:0:0:0: [sdb] Write Protect is on
sd 4:0:0:0: [sdb] Mode Sense: 03 00 80 00
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
sd 4:0:0:0: [sdb] Write Protect is on
sd 4:0:0:0: [sdb] Mode Sense: 03 00 80 00
sd 4:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 4:0:0:0: [sdb] Attached SCSI removable disk
sd 4:0:0:0: Attached scsi generic sg1 type 0
usb-storage: device scan complete

==========
try mount it (or just blockdev --rereadpt), then write protect become off:
==========

sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 4:0:0:0: [sdb] Assuming drive cache: write through
sd 4:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 4:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1

But under rc5-mm1, after mount command being executed, it is just
mouted as read only partition without set the write-protect to off

I tried "blockdev --rereadpt", it do set the write-protect to off as rc5 kernel.

Below is the output of dmesg under rc5-mm1
==========
usb 1-8: new high speed USB device using ehci_hcd and address 6
usb 1-8: configuration #1 chosen from 1 choice
scsi3 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
scsi 3:0:0:0: Direct-Access                   Newman mp3       PQ: 0 ANSI: 0 CCS
sd 3:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
sd 3:0:0:0: [sdb] Write Protect is on
sd 3:0:0:0: [sdb] Mode Sense: 03 00 80 00
sd 3:0:0:0: [sdb] Assuming drive cache: write through
sd 3:0:0:0: [sdb] 245248 512-byte hardware sectors (126 MB)
sd 3:0:0:0: [sdb] Write Protect is on
sd 3:0:0:0: [sdb] Mode Sense: 03 00 80 00
sd 3:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1

Regards
dave
sd 3:0:0:0: [sdb] Attached SCSI removable disk
sd 3:0:0:0: Attached scsi generic sg1 type 0
usb-storage: device scan complete


Regards
dave
