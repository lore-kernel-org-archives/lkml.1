Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbXKKSdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbXKKSdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 13:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXKKSdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 13:33:38 -0500
Received: from eazy.amigager.de ([213.239.192.238]:60626 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXKKSdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 13:33:37 -0500
Date: Sun, 11 Nov 2007 19:33:35 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Strage buffer behaviour
Message-ID: <20071111183334.GA6770@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I noticed that the kernel (2.6.23.1) seems to buffer only certain
partitions on my system:

$ for i in 1 2 3 4 ; do for j in 1 2 ; do dd if=/dev/sda$i of=/dev/null
bs=1024k count=100 ; done ; done
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 3.01471 seconds, 34.8 MB/s
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 2.86945 seconds, 36.5 MB/s
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 2.92038 seconds, 35.9 MB/s
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 3.00272 seconds, 34.9 MB/s
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 4.07722 seconds, 25.7 MB/s
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 0.0944248 seconds, 1.1 GB/s
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 5.61527 seconds, 18.7 MB/s
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 0.331822 seconds, 316 MB/s

The dd command reads 100 MB from each partition two times in a row. It
looks like sda1 and sda2 are not bufferd (the first 4 dd runs), but
sda3 and sda4 are (the last 4 dd runs).

The computer is a Mac mini with a 2,5" SATA hard disk. The first 2
partitions contain EFI and MacOS X, and are unused in Linux. The last 2
partitions are an ext3 partition for / and an LVM for the rest of the
sytem.

Any hints how the dd/buffering behaviour could be explained? The system
was mostly idle, and the numbers are reproducible across reboots.

Regards,
Tino
