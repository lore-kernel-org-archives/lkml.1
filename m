Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYC1BKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYC1BKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYC1BJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:09:34 -0400
Received: from zrnetservice.com ([209.133.52.163]:58083 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755144AbYC1BJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:09:31 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 4] sparsemem: reduce i386 PAE section size
X-Mercurial-Node: b7d0773c79887ca98d6c9830a5a3ef1b585c4278
Message-Id: <b7d0773c79887ca98d6c.1206664119@localhost>
In-Reply-To: <patchbomb.1206664116@localhost>
Date: Thu, 27 Mar 2008 17:28:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 1G section size makes memory hotplug too coarse in a virtual
environment.  Retuce it by a factor of 2 to 512M.  I would have liked
to make it smaller, but it runs out of reserved flags in the page flags.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
---
 include/asm-x86/sparsemem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/sparsemem.h b/include/asm-x86/sparsemem.h
--- a/include/asm-x86/sparsemem.h
+++ b/include/asm-x86/sparsemem.h
@@ -16,7 +16,7 @@
 
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_PAE
-#  define SECTION_SIZE_BITS	30
+#  define SECTION_SIZE_BITS	29
 #  define MAX_PHYSADDR_BITS	36
 #  define MAX_PHYSMEM_BITS	36
 # else


