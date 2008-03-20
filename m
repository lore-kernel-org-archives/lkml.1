Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYCTOhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYCTOhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbYCTOgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:36:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:55732 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755389AbYCTOgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:36:50 -0400
X-Authenticated: #3035711
X-Provags-ID: V01U2FsdGVkX1+nHXAoX/CnpdcrTCNm449rRWFqtyUPK6Zi9kGcvX
	8cgG1mlYIiZvxD
Message-ID: <47E27680.5070306@gmx.de>
Date: Thu, 20 Mar 2008 15:36:48 +0100
From: Ingo van Lil <inguin@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080226 Fedora/2.0.0.12-1.fc8 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Memory corruption in block2mtd.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

the block2mtd driver (drivers/mtd/devices/block2mtd.c) will kfree an
on-stack pointer when handling an invalid argument line (e.g.
block2mtd=/dev/loop0,xxx).

The kfree was added some time ago when "name" was dynamically
allocated.

Cheers,
Ingo

Signed-off-by: Ingo van Lil <inguin@gmx.de>
---

--- linux-2.6.23.1/drivers/mtd/devices/block2mtd.c.orig	2008-03-20 15:13:49.000000000 +0100
+++ linux-2.6.23.1/drivers/mtd/devices/block2mtd.c	2008-03-20 15:14:09.000000000 +0100
@@ -408,7 +408,6 @@
  	if (token[1]) {
  		ret = parse_num(&erase_size, token[1]);
  		if (ret) {
-			kfree(name);
  			parse_err("illegal erase size");
  		}
  	}
