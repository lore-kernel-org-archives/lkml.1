Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYIYCFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYIYCFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYIYCFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:05:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:64591 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYIYCFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lWCnOIJC56YYisjW6sMNEwsw9rgLbQXEBuhWpvn+YL5imRiEfnQNvBR3v2bsTs7c+b
         63TuHzJGKK5U5qZwyPlB3oYZwgLPn5tS6WYZnIHjWJ28y6AQwM3Oub+1c983XhxmAsXO
         4MEbcMQx/zbWMKsWswDkAmPrzk/YE4H6Pc5dA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/7] acpi: don't load acpi_cpufreq if acpi=off
Date: Wed, 24 Sep 2008 19:04:31 -0700
Message-Id: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index dd097b8..9943b4c 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -779,6 +779,9 @@ static int __init acpi_cpufreq_init(void)
 {
 	int ret;
 
+	if (acpi_disabled)
+		return 0;
+
 	dprintk("acpi_cpufreq_init\n");
 
 	ret = acpi_cpufreq_early_init();
-- 
1.5.6

