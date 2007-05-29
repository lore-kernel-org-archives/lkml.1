Return-Path: <linux-kernel-owner+w=401wt.eu-S1764990AbXE2Ue5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764990AbXE2Ue5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932262AbXE2UeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:34:19 -0400
Received: from gw.goop.org ([64.81.55.164]:52870 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbXE2UeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:34:18 -0400
Message-ID: <465C8E4B.9080304@goop.org>
Date: Tue, 29 May 2007 13:34:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen_start_kernel is __init, so startup_xen should be too
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This needs an update to modpost to prevent warning about the reference from
.note* to the .init.text section.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com> 
Cc: Sam Ravnborg <sam@ravnborg.org>

---
 arch/i386/xen/xen-head.S |    2 ++
 1 file changed, 2 insertions(+)

===================================================================
--- a/arch/i386/xen/xen-head.S
+++ b/arch/i386/xen/xen-head.S
@@ -7,11 +7,13 @@
 #include <asm/boot.h>
 #include <xen/interface/elfnote.h>
 
+.pushsection .init.text,"ax",@progbits
 ENTRY(startup_xen)
 	movl %esi,xen_start_info
 	cld
  	movl $(init_thread_union+THREAD_SIZE),%esp
 	jmp xen_start_kernel
+.popsection
 
 .pushsection ".bss.page_aligned"
 	.align PAGE_SIZE_asm


