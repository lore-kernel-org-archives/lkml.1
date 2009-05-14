Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbZENIuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbZENIuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 04:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZENIt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 04:49:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:56376 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbZENIt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 04:49:58 -0400
Subject: [PATCH -tip] x86: apic/apic.c default_init_apic_ldr() is required
 only for X86_32
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0905140952220.3561@localhost.localdomain>
References: <1242251841.3364.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0905140952220.3561@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 May 2009 14:19:12 +0530
Message-Id: <1242290952.3178.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 09:53 +0200, Thomas Gleixner wrote:
> On Thu, 14 May 2009, Jaswinder Singh Rajput wrote:
> > 
> > default_init_apic_ldr() is also required for 64 bit so moving it out
> > from CONFIG_X86_32.
> 
> [linux-2.6-tip]$ git grep default_init_apic_ldr arch/x86/
> arch/x86/include/asm/apic.h:extern void default_init_apic_ldr(void);
> arch/x86/kernel/apic/apic.c:void default_init_apic_ldr(void)
> arch/x86/kernel/apic/probe_32.c:        .init_apic_ldr                  = default_init_apic_ldr,
> 
> I have a hard time to see how 64bit requires that function.
> 

Here is new patch to make you easy :-)

[PATCH] x86: apic/apic.c default_init_apic_ldr() is required only for X86_32

default_init_apic_ldr() is used only by X86_32.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d6d4ffd..6ae5303 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1941,6 +1941,7 @@ int hard_smp_processor_id(void)
 	return read_apic_id();
 }
 
+#ifdef CONFIG_X86_32
 void default_init_apic_ldr(void)
 {
 	unsigned long val;
@@ -1951,7 +1952,6 @@ void default_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-#ifdef CONFIG_X86_32
 int default_apicid_to_node(int logical_apicid)
 {
 #ifdef CONFIG_SMP
-- 
1.6.0.6



