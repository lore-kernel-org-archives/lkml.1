Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbXIOWVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbXIOWVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 18:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbXIOWVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 18:21:01 -0400
Received: from hera.cwi.nl ([192.16.191.8]:43406 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbXIOWVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 18:21:00 -0400
X-Greylist: delayed 2022 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 18:21:00 EDT
Date: Sat, 15 Sep 2007 23:49:31 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: linux-kernel@vger.kernel.org
Subject: iso9660 vs udf
Message-ID: <20070915214926.GA31416@mette>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Today I got a CD. MacOS does not mount it and Linux does not
mount it without an explicit filesystemtype option.
That is,
	# mount /dev/hdc /dir -t iso9660
works fine, but
	# mount /dev/hdc /dir
	mount: you didn't specify a filesystem type for /dev/hdc
               I will try type udf
        mount: wrong fs type, bad option, bad superblock on /dev/hdc,
               missing codepage or other error
               In some cases useful info is found in syslog - try
               dmesg | tail  or so
	# dmesg | tail
        UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'Wisk1956-82', timestamp 2006/03/07 16:26 (1078)
        udf: udf_read_inode(ino 547) failed !bh
        UDF-fs: Error in udf_iget, block=1, partition=1

Google gave me half a dozen other people that mentioned the same
problem (with the same inode 547). Clearly some CD mastering software
produces a format that Linux and MacOS do not handle easily.

One result of this letter will be that people with the same problem
learn via Google that using the "-t iso9660" option may help.

What goes wrong on the mount side is that when it hesitates between
iso9660 and udf it decides for udf when seeing "NSR02".
Maybe the heuristics in mount should be tuned.

On the other hand, this filesystem announces itself as UDF
("CD-RTOS" "CD-BRIDGE" "CDUDF File System - Adaptec Inc"),
perhaps the kernel code should be more robust.

If anybody feels responsible for mount and/or this kernel area
we might discuss.

Andries

