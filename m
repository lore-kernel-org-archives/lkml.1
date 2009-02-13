Return-Path: <linux-kernel-owner+w=401wt.eu-S1762131AbZBMV4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762131AbZBMV4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZBMVyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:54:17 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:55389 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZBMVyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:54:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=eWnyafith6/zuPdVtVOpm3I7Y+Ntc01J2aVBjEIIAAHrWjwmIlAu40UzCdsozWoMqr
         gFCz0/fLi/ykCx/lnnGRtNUJsRncQpTCpQtz8o0nDabAf+Qp/lSVg0zsdcHttZ8UwKFF
         /YCeC/MPcuIgdIuf6dHqeum0KEdpY/wtmNBPw=
Message-Id: <20090213215404.146776098@gmail.com>
User-Agent: quilt/0.47-1
Date: Sat, 14 Feb 2009 00:50:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, heukelum@fastmail.fm
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 1/6] x86: asm linkage - introduce GLOBAL macro
References: <20090213215017.959278111@gmail.com>
Content-Disposition: inline; filename=x86-linkage-global
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the code is time critical and this entry is called
from other places we use ENTRY to have it globally defined
and especially aligned.

Contrary we have some snippets which are size
critical. So we use plane ".globl name; name:"
directive. Introduce GLOBAL macro for this.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/linkage.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.git/arch/x86/include/asm/linkage.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/linkage.h
+++ linux-2.6.git/arch/x86/include/asm/linkage.h
@@ -52,6 +52,10 @@
 
 #endif
 
+#define GLOBAL(name)	\
+	.globl name;	\
+	name:
+
 #ifdef CONFIG_X86_ALIGNMENT_16
 #define __ALIGN .align 16,0x90
 #define __ALIGN_STR ".align 16,0x90"

