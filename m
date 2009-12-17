Return-Path: <linux-kernel-owner+w=401wt.eu-S936665AbZLQEkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936665AbZLQEkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936658AbZLQEil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:38:41 -0500
Received: from kroah.org ([198.145.64.141]:55428 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763958AbZLQEED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:48 2009
Message-Id: <20091217035647.992413232@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Cliff Wickman <cpw@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: [039/151] x86: Fix duplicated UV BAU interrupt vector
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cliff Wickman <cpw@sgi.com>

commit 1d865fb728bd6bbcdfbd6ec1e2b8ade3b4805641 upstream.

Interrupt vector 0xec has been doubly defined in irq_vectors.h

It seems arbitrary whether LOCAL_PENDING_VECTOR or
UV_BAU_MESSAGE is the higher number.  As long as they are
unique. If they are not unique we'll hit a BUG in
alloc_system_vector().

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1NJ9Pe-0004P7-0Q@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/irq_vectors.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -113,7 +113,7 @@
  */
 #define LOCAL_PENDING_VECTOR		0xec
 
-#define UV_BAU_MESSAGE			0xec
+#define UV_BAU_MESSAGE			0xea
 
 /*
  * Self IPI vector for machine checks


