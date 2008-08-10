Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYHJWKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYHJWKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 18:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYHJWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 18:10:04 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:40071 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbYHJWKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 18:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=r9dnv6EfAmtsJ/bH6CaIxzUG6X+9o+o6oWi+UJa7kZkxpcIVhA7LpG6z1iXCY4bQRK
         7OP3eEsUknS1BAxJouPQ2mkeB/9AFGEMTDUmjg+pHFuzKEPubgZaHf6+Qe8zyI94Zlta
         WKOkaF/cYfe04n9MUUtmu59NMsvxjDvIJWUUc=
Date: Mon, 11 Aug 2008 00:09:38 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH] x86: mpparse.c: fix section mismatch warning
Message-ID: <20080810220934.GB27349@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0x118f7): Section mismatch in reference from the function construct_ioapic_table() to the function .init.text:MP_bus_info()
The function construct_ioapic_table() references
the function __init MP_bus_info().
This is often because construct_ioapic_table lacks a __init
annotation or the annotation of MP_bus_info is wrong.

construct_ioapic_table is called only from construct_default_ISA_mptable which is __init

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/mpparse.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6ae005c..a7189f4 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -484,7 +484,7 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 }
 
 
-static void construct_ioapic_table(int mpc_default_type)
+static void __init construct_ioapic_table(int mpc_default_type)
 {
 	struct mpc_config_ioapic ioapic;
 	struct mpc_config_bus bus;
@@ -529,7 +529,7 @@ static void construct_ioapic_table(int mpc_default_type)
 	construct_default_ioirq_mptable(mpc_default_type);
 }
 #else
-static inline void construct_ioapic_table(int mpc_default_type) { }
+static inline void __init construct_ioapic_table(int mpc_default_type) { }
 #endif
 
 static inline void __init construct_default_ISA_mptable(int mpc_default_type)
-- 
1.5.4.5

