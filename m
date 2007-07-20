Return-Path: <linux-kernel-owner+w=401wt.eu-S936911AbXGTPfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936911AbXGTPfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935984AbXGTPdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:33:04 -0400
Received: from ns2.suse.de ([195.135.220.15]:54407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935958AbXGTPdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:33:00 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [11/11] i386: Use patchable lock prefix in set_64bit
Message-Id: <20070720153256.DACA614E7B@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Previously lock was unconditionally used, but shouldn't be needed on
UP systems.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/asm-i386/cmpxchg.h
===================================================================
--- linux.orig/include/asm-i386/cmpxchg.h
+++ linux/include/asm-i386/cmpxchg.h
@@ -34,7 +34,7 @@ static inline void __set_64bit (unsigned
 		"\n1:\t"
 		"movl (%0), %%eax\n\t"
 		"movl 4(%0), %%edx\n\t"
-		"lock cmpxchg8b (%0)\n\t"
+		LOCK_PREFIX "cmpxchg8b (%0)\n\t"
 		"jnz 1b"
 		: /* no outputs */
 		:	"D"(ptr),
