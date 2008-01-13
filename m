Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYAMWrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYAMWrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 17:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYAMWr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 17:47:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:33126 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbYAMWrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 17:47:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=HxC4TybMgwn4fjtZi6gXTepqzwE9S9rBhThX0MIxj6b3S4Q76ZUjfTuMKEIu/Hg0KQaPsVy+dq1sYIYz88lZsYJkHi8w7g2RwM+y7MftS6G7f6EZ04MxsiN67EfiixdgjA5kdfQN5RB21A4TJ98jt1cZVIQCr4KNfKkOgL7DH70=
Message-ID: <478A94FC.1050607@gmail.com>
Date: Sun, 13 Jan 2008 23:47:24 +0100
From: =?UTF-8?B?TWlndWVsIEJvdMOzbg==?= <mboton@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, oakad@exemail.com.au,
       linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happens when trying to compile memory stick support inside the kernel.

drivers/memstick/core/mspro_block.o: In function `memstick_priv':
mspro_block.c:(.text+0x0): multiple definition of `memstick_priv'
drivers/memstick/core/memstick.o:memstick.c:(.text+0x0): first defined here
drivers/memstick/core/mspro_block.o: In function `memstick_get_drvdata':
mspro_block.c:(.text+0x6): multiple definition of `memstick_get_drvdata'
drivers/memstick/core/memstick.o:memstick.c:(.text+0x6): first defined here
drivers/memstick/core/mspro_block.o: In function `memstick_set_drvdata':
mspro_block.c:(.text+0xd): multiple definition of `memstick_set_drvdata'
drivers/memstick/core/memstick.o:memstick.c:(.text+0xd): first defined here 

This is because those three functions are not defined as static in "include/linux/memstick.h".

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index dc5ac9d..53a8741 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -271,17 +271,17 @@ void memstick_new_req(struct memstick_host *host);
 
 int memstick_set_rw_addr(struct memstick_dev *card);
 
-inline void *memstick_priv(struct memstick_host *host)
+static inline void *memstick_priv(struct memstick_host *host)
 {
 	return (void *)host->private;
 }
 
-inline void *memstick_get_drvdata(struct memstick_dev *card)
+static inline void *memstick_get_drvdata(struct memstick_dev *card)
 {
 	return dev_get_drvdata(&card->dev);
 }
 
-inline void memstick_set_drvdata(struct memstick_dev *card, void *data)
+static inline void memstick_set_drvdata(struct memstick_dev *card, void *data)
 {
 	dev_set_drvdata(&card->dev, data);
 }

---
	Miguel Botón
