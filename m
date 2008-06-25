Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbYFYEhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbYFYEhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYFYEhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:05 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37418 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752459AbYFYEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:04 -0400
X-Greylist: delayed 671 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 00:37:03 EDT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 36] x86: add memory clobber to save/loadsegment
X-Mercurial-Node: 2289309bb2cdf23bf825848aca0cbc1abe1fe019
Message-Id: <2289309bb2cdf23bf825.1214367538@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:18:58 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "memory" clobbers to savesegment and loadsegment, since they can
affect memory accesses and we never want the compiler to reorder them
with respect to memory references.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/system.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -157,14 +157,14 @@
 		     "jmp 2b\n"			\
 		     ".previous\n"		\
 		     _ASM_EXTABLE(1b,3b)	\
-		     : :"r" (value), "r" (0))
+		     : :"r" (value), "r" (0) : "memory")
 
 
 /*
  * Save a segment register away
  */
 #define savesegment(seg, value)				\
-	asm volatile("mov %%" #seg ",%0":"=rm" (value))
+	asm("mov %%" #seg ",%0":"=rm" (value) : : "memory")
 
 static inline unsigned long get_limit(unsigned long segment)
 {


