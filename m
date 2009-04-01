Return-Path: <linux-kernel-owner+w=401wt.eu-S1764885AbZDANlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764885AbZDANlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759804AbZDANlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:41:07 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:33139 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107AbZDANlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Se/6+KOT4dY5vBnZAh0Q2uW48VJJZJYVBH9Tb1ILv/nquIku2qgvU3SZK1vLOEOq8f
         Bb7b6XAh5lAbY1DlsVocWwNohIrnWQKiT7MV0HFNJqK1TF7qtyo793xOqF9KWms4jCTr
         8ZBPM06O7LWQvi4xYCty2IoDXkzmNMNzGAo2w=
From: Andreas Robinson <andr345@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] lib, initramfs: Add initramfs LZO compression
Date: Wed,  1 Apr 2009 15:40:50 +0200
Message-Id: <1238593252-3435-1-git-send-email-andr345@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this small patchset adds support for compressing initial ramdisks
into LZO (Lempel Ziv Oberhumer) format. It has been tested on x86
and x86_64. The patches apply to current git mainline.

In a pair of real-world examples, an Eee 901 boots ~120 ms faster.
A high-end desktop only saves an inconsequential 35 ms.

Specs: 

* LZO data decompresses in 55 - 60% of the time needed by gzip,
  when using the 'fast' decompressor.
* The decompressor is very small, < 2 kB on x86.
* An LZO-compressed initramfs takes 7-10% more disk space vs gzip.

Test results:

initramfs.cpio: 14174 kB 
initramfs.gz:    4657 kB
initramfs.lzo:   5007 kB

            Eee 901    Core i7 920
           SSD 30MB/s  HDD 60MB/s

            gz  lzo     gz  lzo

disk read  152  163     76   82
unpacking  247  113     95   54
----------------------------------
total      399  276    171  136

net gain     123          35 

All values are milliseconds. Disk read times are estimates.

I have a patch that adds support for LZO-compressed kernels but
decided to not include it now since it's only implemented for x86.

Cheers,
Andreas

