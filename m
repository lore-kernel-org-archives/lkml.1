Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbXB1Xjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbXB1Xjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXB1Xjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:39:43 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:3818 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXB1Xjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:39:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 28 Feb 2007 23:39:39.0479 (UTC) FILETIME=[B6928670:01C75B91]
Content-class: urn:content-classes:message
Subject: Ramdisk size
Date: Wed, 28 Feb 2007 18:39:39 -0500
Message-ID: <Pine.LNX.4.61.0702281837020.4181@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Ramdisk size
Thread-Index: Acdbkba2lP4jErnEQhqRYzadX736GQ==
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,
On an embedded system, I use two ramdisks. They are both
16 megabytes in size. I can create them interactively in
the normal way with mke2fs. However, when the system is
booted using isolinux, the RAM disks become corrupted.
Apparently isolinux.cfg's ramdisk_size (not documented,
only referenced, BYW) is not in 1k increments. That value
seems to affect all ramdisks, not just the `initrd` one.
I can prevent corruption by setting the value to 200000
(way too much). However I won't have any RAM left for
applications! I need to know how much RAM a ramdisk of
16386 bytes takes, and how to set it in isolinux.cfg
(what the multiplier is).

The file-system mounts properly, but a write of one byte
causes the following error:

EXT-FS error (Device ram2);
ext2_new_block: Allocation block in system zone block = 129

e2fsck reports:
 	+(129--256) + (8321--8448)
 	block bitmap differences

It's difficult to find out what is being corrupted because
`mke2fs` never creates the same thing twice!! There is some
time-stuff in it, therefore I can't find out what actually
is getting trashed. Currently, it doesn't look like anything
at the ends of the raw disk get trashed. Instead, it looks
like the ramdisk size when booted using isolinux is simply
not the same size as when the ramdisk contents were created.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.65 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
