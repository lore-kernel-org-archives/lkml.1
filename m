Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbXGEEwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbXGEEwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 00:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXGEEwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 00:52:36 -0400
Received: from pc125.solomon-systech.com ([202.76.106.125]:23114 "HELO
	virus-gateway.solomon-systech.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751624AbXGEEwg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 00:52:36 -0400
X-Greylist: delayed 3638 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2007 00:52:35 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: CRAMFS support for 4KB page NAND FLASH
Date: Thu, 5 Jul 2007 11:51:46 +0800
Message-ID: <6334E09627481B4AA5C8DE1E69E19D3B06BF98AD@SSLEXCHANGE.solomonsystech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: CRAMFS support for 4KB page NAND FLASH
Thread-Index: Ace+t9HOUmYJNt3TTa6d1fLPuBkXyg==
From: <sasin@solomon-systech.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to boot off CRAMFS on a 4KB page NAND FLASH (new device), I ran
into the "wrong magic" issue.  MTD's nand_read
(drivers/mtd/nand/nand_base.c) is returning the right data.
cramfs_fill_supper calls cramfs_read (fs/cramfs/inode.c) which reads 4
pages and the 1st page of data gets corrupted.  If I set
BLKS_PER_BUF_SHIFT in this file to 0 instead of 2, so that only 1 page
is read, the data is uncorrupted and the magic value matches but it
crashes later (comments say that this values should be 2 or higher, so
this is not surprising).  

So are 4KB-page devices supported by CRAMFS?

I'm using linux 2.6.20.1 for ARM. 
