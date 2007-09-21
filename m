Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbXIUWku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbXIUWku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762394AbXIUWcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:40481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762428AbXIUWcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:25 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: chuck.lever@oracle.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [24/50] x86_64: Eliminate result signage problem in asm-x86_64/bitops.h
Message-Id: <20070921223223.6B85E13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Chuck Lever <chuck.lever@oracle.com>
The return type of __scanbit() doesn't match the return type of
find_{first,next}_bit().  Thus when you construct something like
this:

   boolean ? __scanbit() : find_first_bit()

you get an unsigned long result if "boolean" is true, and a signed
long result if "boolean" is false.

In file included from /home/cel/src/linux/include/linux/mmzone.h:15,
                 from /home/cel/src/linux/include/linux/gfp.h:4,
                 from /home/cel/src/linux/include/linux/slab.h:14,
                 from /home/cel/src/linux/include/linux/percpu.h:5,
                 from
/home/cel/src/linux/include/linux/rcupdate.h:41,
                 from /home/cel/src/linux/include/linux/dcache.h:10,
                 from /home/cel/src/linux/include/linux/fs.h:275,
                 from /home/cel/src/linux/fs/nfs/sysctl.c:9:
/home/cel/src/linux/include/linux/nodemask.h: In function
‘__first_node’:
/home/cel/src/linux/include/linux/nodemask.h:229: warning: signed and
unsigned type in conditional expression
/home/cel/src/linux/include/linux/nodemask.h: In function
‘__next_node’:
/home/cel/src/linux/include/linux/nodemask.h:235: warning: signed and
unsigned type in conditional expression
/home/cel/src/linux/include/linux/nodemask.h: In function
‘__first_unset_node’:
/home/cel/src/linux/include/linux/nodemask.h:253: warning: signed and
unsigned type in conditional expression

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-x86_64/bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/asm-x86_64/bitops.h
===================================================================
--- linux.orig/include/asm-x86_64/bitops.h
+++ linux/include/asm-x86_64/bitops.h
@@ -260,7 +260,7 @@ extern long find_first_bit(const unsigne
 extern long find_next_bit(const unsigned long * addr, long size, long offset);
 
 /* return index of first bet set in val or max when no bit is set */
-static inline unsigned long __scanbit(unsigned long val, unsigned long max)
+static inline long __scanbit(unsigned long val, unsigned long max)
 {
 	asm("bsfq %1,%0 ; cmovz %2,%0" : "=&r" (val) : "r" (val), "r" (max));
 	return val;
