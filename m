Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0BXDeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:34:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44756 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab0BXDeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:34:11 -0500
Date: Wed, 24 Feb 2010 14:34:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
       Alex Chiang <achiang@hp.com>, Len Brown <len.brown@intel.com>
Subject: linux-next: manual merge of the cpufreq tree with the acpi tree
Message-Id: <20100224143408.69e0c889.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the cpufreq tree got a conflict in
drivers/acpi/processor_core.c between commit
5f45c35d7ede1c00cbaa3b09b8a84c425af81c4b ("ACPI: processor: mv
processor_core.c processor_driver.c") from the acpi tree and commit
0f1d683fb35d6c6f49ef696c95757f3970682a0e ("[CPUFREQ] Processor Clocking
Control interface driver") from the cpufreq tree.

I applied the equivalent patch to processor_driver.c (see below) and can
carry this as necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 24 Feb 2010 14:29:12 +1100
Subject: [PATCH] cpufreq: merge fixup for processor_core.c rename

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/acpi/processor_driver.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 7e8e1ba..b5658cd 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -123,6 +123,8 @@ static const struct file_operations acpi_processor_info_fops = {
 #endif
 
 DEFINE_PER_CPU(struct acpi_processor *, processors);
+EXPORT_PER_CPU_SYMBOL(processors);
+
 struct acpi_processor_errata errata __read_mostly;
 
 /* --------------------------------------------------------------------------
-- 
1.7.0

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
