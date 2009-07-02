Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbZGBFnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbZGBFnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbZGBFmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:42:55 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:58428 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZGBFmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PJ94VCUwrHepoRG7KdpER+4JFMQD6tB2Z6Cl/qNxN36lFiV2JzH4eM/q5PLwMprEwJ
         xe637ArcfajMnFCNGxTE18LzC4VYVABhcVCMdWOl9TVOVCmcvWqJxljNeLUPyrgq9z++
         48M+HFzpP5oE2jL6+FLkXwolNgFpguq39QzQs=
MIME-Version: 1.0
Date: Thu, 2 Jul 2009 11:40:36 +0600
Message-ID: <b9df5fa10907012240y356427b8ta4bd07f0efc6a049@mail.gmail.com>
Subject: [PATCH] x86,kvm: Fix section mismatches in kvm.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: avi@qumranet.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: Fix section mismatch.

The function paravirt_ops_setup() has been refering the variable
no_timer_check, which is a __initdata. Thus generates the following
warning. paravirt_ops_setup() function is called from kvm_guest_init()
which is a __init function. So to fix this we mark paravirt_ops_setup
as __init.

Thanks,

 LD      arch/x86/built-in.o
WARNING: arch/x86/built-in.o(.text+0x166ce): Section mismatch in
reference from the function paravirt_ops_setup() to the variable
.init.data:no_timer_check
The function paravirt_ops_setup() references
the variable __initdata no_timer_check.
This is often because paravirt_ops_setup lacks a __initdata
annotation or the annotation of no_timer_check is wrong.

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/kernel/kvm.c	2009-07-01 20:43:56.124988432 +0600
+++ rakib/arch/x86/kernel/kvm.c	2009-07-01 20:42:38.000000000 +0600
@@ -200,7 +200,7 @@ static void kvm_leave_lazy_mmu(void)
 	state->mode = paravirt_get_lazy_mode();
 }

-static void paravirt_ops_setup(void)
+static void __init paravirt_ops_setup(void)
 {
 	pv_info.name = "KVM";
 	pv_info.paravirt_enabled = 1;
