Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbZDSHnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbZDSHnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 03:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZDSHnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 03:43:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:19639 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZDSHnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 03:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IwKK1SNJlPljNfa35/OXlA77SLL7JrwbfdhtrlOOgtghCL6fBl7VvpoebyFueRUka3
         HhVe3ARQHVX6ISyvUjBuxrNac2yERp5eAukLYVYXUwlDzYctE+jjAsl0oeXIIRCwNkAp
         F/xlx5eqL8419+3yk8WJmtYCDo3R4D8fkZfio=
Date: Sun, 19 Apr 2009 11:43:11 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: [PATCH -tip] x86: es7000, uv - use __cpuinit for kicking secondary
	cpus
Message-ID: <20090419074311.GA8670@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The caller already has __cpuinit attribute.

[ Impact: cleanup ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

I've no ability to test this but it should not bring
any problems I believe.

 arch/x86/kernel/apic/es7000_32.c   |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/es7000_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/es7000_32.c
+++ linux-2.6.git/arch/x86/kernel/apic/es7000_32.c
@@ -145,7 +145,7 @@ es7000_rename_gsi(int ioapic, int gsi)
 	return gsi;
 }
 
-static int wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
+static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
 	unsigned long vect = 0, psaival = 0;
 
Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -105,7 +105,7 @@ static void uv_vector_allocation_domain(
 	cpumask_set_cpu(cpu, retmask);
 }
 
-static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
+static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
 #ifdef CONFIG_SMP
 	unsigned long val;
