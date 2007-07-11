Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbXGKSxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbXGKSxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbXGKSxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:53:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145AbXGKSxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:53:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Pass -g to assembler under CONFIG_DEBUG_INFO
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Puerile string-art
   (2) Meteoritic sleeves
   (3) Incumbent eruption L'eggs
   (4) Typical caution
Message-Id: <20070711185334.1B8894D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 11:53:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The assembler for a while now supports -g to generate source line info just
like the C compiler does.  Source-level assembly debugging sounds like an
oxymoron, but it is handy to be able to see the right source file and read
its comments rather than just the disassembly.  This patch enables -g for
assembly files when CONFIG_DEBUG_INFO=y and the assembler supports the option.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 8a3c271..88b2252 100644
--- a/Makefile
+++ b/Makefile
@@ -498,6 +498,7 @@ endif
 
 ifdef CONFIG_DEBUG_INFO
 CFLAGS		+= -g
+AFLAGS		+= $(call as-option, -g)
 endif
 
 # Force gcc to behave correct even for buggy distributions
