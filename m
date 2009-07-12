Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbZGLLEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbZGLLEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 07:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZGLLEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 07:04:14 -0400
Received: from ey-out-1920.google.com ([74.125.78.145]:62575 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZGLLEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 07:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=E1GPHvLPsV2Ymqe5F3kSNhXGFNPlZrvuEiCQoGXxtEp03GCxOuBeBlJUVGZ38gv+qh
         uWwoSJgyFQAfLcKGXHyCA8OSvp9Ql9i81x9C2e0OO9UHX8jo8OaUOCLw2wUGLAmNC41N
         fCbnMU1SolZlCfcwJC6mNH62+8CedeXZWq8mg=
MIME-Version: 1.0
Date: Sun, 12 Jul 2009 17:04:12 +0600
Message-ID: <b9df5fa10907120404k6279a10ch5e9682432272706f@mail.gmail.com>
Subject: [PATCH] x86: Fix false positive section mismatch in es7000_32.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: Fix false positive warning

The variable apic_es7000_cluster references the function __cpuinit
wakeup_secondary_cpu_via_mip() from a noninit section. So we've been
warned by the following warning. To avoid possible collision between
init/noninit, its best to mark the variable as __refdata.

 We were warned by the followin warning:

 LD      arch/x86/kernel/apic/built-in.o
WARNING: arch/x86/kernel/apic/built-in.o(.data+0x198c): Section
mismatch in reference from the variable apic_es7000_cluster to the
function .cpuinit.text:wakeup_secondary_cpu_via_mip()
The variable apic_es7000_cluster references
the function __cpuinit wakeup_secondary_cpu_via_mip()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/kernel/apic/es7000_32.c	2009-07-10 12:30:10.000000000 +0600
+++ rakib/arch/x86/kernel/apic/es7000_32.c	2009-07-12 11:21:10.000000000 +0600
@@ -652,7 +652,8 @@ static int es7000_mps_oem_check_cluster(
 	return ret && es7000_apic_is_cluster();
 }

-struct apic apic_es7000_cluster = {
+/* We've been warned by a false positive warning.Use __refdata to keep calm. */
+struct apic __refdata apic_es7000_cluster = {

 	.name				= "es7000",
 	.probe				= probe_es7000,
