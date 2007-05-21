Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbXEUJWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbXEUJWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbXEUJWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:22:32 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:37661 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbXEUJWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:22:32 -0400
Message-ID: <465165B8.8010504@openvz.org>
Date: Mon, 21 May 2007 13:26:16 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix x86_64 boot/memory.c compilation (a misprint)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a misprint in arch/i386/boot/memory.c file that leads
to error in x86_64 compilation:

...
  CC      arch/x86_64/boot/memory.o
arch/i386/boot/memory.c: In function `detect_memory':
arch/i386/boot/memory.c:32: error: can't find a register in class `DREG' while reloading `asm'

The err variable is specified in asm output list like "=dm", not "=m".

This is for 2.6.22-rc1-mm1 tree. Maybe this exists in i386 as well 
and the patch is sent, but...

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
index 8a82aa9..7ae2d23 100644
--- a/arch/i386/boot/memory.c
+++ b/arch/i386/boot/memory.c
@@ -30,7 +30,7 @@ static int detect_memory_e820(void)
 		size = sizeof(struct e820entry);
 		id = SMAP;
 		asm("int $0x15; setc %0"
-		    : "=dm" (err), "+b" (next), "+d" (id), "+c" (size),
+		    : "=m" (err), "+b" (next), "+d" (id), "+c" (size),
 		      "=m" (*desc)
 		    : "D" (desc), "a" (0xe820));
 
