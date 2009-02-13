Return-Path: <linux-kernel-owner+w=401wt.eu-S1760674AbZBMVzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbZBMVzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZBMVyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:54:16 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:33328 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbZBMVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:54:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=DInqwJafaJlUvcTGzim0Z2HoNckZYGOss9zYXvmS0Sga3s0orF7p6WyTKc9/T81Oxh
         BjeHjZ2/T4Zf/RoLj7CFPrEJ9ZdDvjOQuOVftHNuMyAFhfFHH+NuDKOYOSseH+WU98TK
         oZeRVJ95Jov/Q6NkLab7NiXNh3HjMy9LvD2p4=
Message-Id: <20090213215404.857506855@gmail.com>
User-Agent: quilt/0.47-1
Date: Sat, 14 Feb 2009 00:50:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, heukelum@fastmail.fm
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 6/6] x86: compressed head_32 - use ENTRY,ENDPROC macros
References: <20090213215017.959278111@gmail.com>
Content-Disposition: inline; filename=x86-compressed-head-32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: clenaup

Linker script will put startup_32 at predefined
address so using startup_32 will not bloat the
code size.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/boot/compressed/head_32.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/boot/compressed/head_32.S
===================================================================
--- linux-2.6.git.orig/arch/x86/boot/compressed/head_32.S
+++ linux-2.6.git/arch/x86/boot/compressed/head_32.S
@@ -30,9 +30,7 @@
 #include <asm/asm-offsets.h>
 
 .section ".text.head","ax",@progbits
-	.globl startup_32
-
-startup_32:
+ENTRY(startup_32)
 	cld
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 	 * us to not reload segments */
@@ -113,6 +111,8 @@ startup_32:
  */
 	leal relocated(%ebx), %eax
 	jmp *%eax
+ENDPROC(startup_32)
+
 .section ".text"
 relocated:
 

