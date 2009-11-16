Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZKPXfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZKPXfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbZKPXfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:35:15 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:38667 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbZKPXfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:35:11 -0500
Date: Mon, 16 Nov 2009 15:32:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lenb@kernel.org,
       cpufreq@vger.kernel.org, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, davej@redhat.com
Subject: [PATCH -next] x86/cpufreq: don't use acpi_processor_get_bios_limit
 when not available
Message-Id: <20091116153242.3c194a5a.randy.dunlap@oracle.com>
In-Reply-To: <20091116181453.b42247cf.sfr@canb.auug.org.au>
References: <20091116181453.b42247cf.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B01E17B.018A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Only reference this function when the kconfig makes it available.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20091113.orig/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ linux-next-20091113/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -717,7 +717,9 @@ static struct cpufreq_driver powernow_dr
 	.verify		= powernow_verify,
 	.target		= powernow_target,
 	.get		= powernow_get,
+#ifdef CONFIG_X86_POWERNOW_K7_ACPI
 	.bios_limit	= acpi_processor_get_bios_limit,
+#endif
 	.init		= powernow_cpu_init,
 	.exit		= powernow_cpu_exit,
 	.name		= "powernow-k7",
