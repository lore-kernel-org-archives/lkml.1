Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbZGAAn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbZGAAn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760998AbZGAAcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:54 -0400
Received: from kroah.org ([198.145.64.141]:59828 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760984AbZGAAcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:51 2009
Message-Id: <20090701001551.690481544@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 20/35] lockdep: Select frame pointers on x86
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=lockdep-select-frame-pointers-on-x86.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 00540e5d54be972a94a3b2ce6da8621bebe731a2 upstream.

x86 stack traces are a piece of crap without frame pointers, and its not
like the 'performance gain' of not having stack pointers matters when you
selected lockdep.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -402,7 +402,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !X86 && !MIPS && !PPC
+	select FRAME_POINTER if !MIPS && !PPC
 	select KALLSYMS
 	select KALLSYMS_ALL
 


