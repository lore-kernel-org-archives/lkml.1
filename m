Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZK3TeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZK3TeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZK3Td7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:33:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:35574 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbZK3Td6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:33:58 -0500
Date: Mon, 30 Nov 2009 19:33:38 GMT
From: "tip-bot for Helight.Xu" <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, helight.xu@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, helight.xu@gmail.com
In-Reply-To: <4B139F8F.4000907@gmail.com>
References: <4B139F8F.4000907@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Fix a section mismatch in arch/x86/kernel/setup.c
Message-ID: <tip-9eaa192d8988d621217a9e6071cd403fd6010496@git.kernel.org>
Git-Commit-ID: 9eaa192d8988d621217a9e6071cd403fd6010496
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9eaa192d8988d621217a9e6071cd403fd6010496
Gitweb:     http://git.kernel.org/tip/9eaa192d8988d621217a9e6071cd403fd6010496
Author:     Helight.Xu <helight.xu@gmail.com>
AuthorDate: Mon, 30 Nov 2009 18:33:51 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 30 Nov 2009 11:16:49 -0800

x86: Fix a section mismatch in arch/x86/kernel/setup.c

copy_edd() should be __init.
warning msg:
WARNING: vmlinux.o(.text+0x7759): Section mismatch in reference from the
function copy_edd() to the variable .init.data:boot_params
The function copy_edd() references
the variable __initdata boot_params.
This is often because copy_edd lacks a __initdata
annotation or the annotation of boot_params is wrong.

Signed-off-by: ZhenwenXu <helight.xu@gmail.com>
LKML-Reference: <4B139F8F.4000907@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e09f0e2..e020b2d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -247,7 +247,7 @@ EXPORT_SYMBOL(edd);
  *              from boot_params into a safe place.
  *
  */
-static inline void copy_edd(void)
+static inline void __init copy_edd(void)
 {
      memcpy(edd.mbr_signature, boot_params.edd_mbr_sig_buffer,
 	    sizeof(edd.mbr_signature));
@@ -256,7 +256,7 @@ static inline void copy_edd(void)
      edd.edd_info_nr = boot_params.eddbuf_entries;
 }
 #else
-static inline void copy_edd(void)
+static inline void __init copy_edd(void)
 {
 }
 #endif
