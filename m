Return-Path: <linux-kernel-owner+w=401wt.eu-S934672AbYBGAiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934672AbYBGAiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932721AbYBGAHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:07:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:32424 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbYBGAHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eN6iV+LN7UIBfHgH95wC2WNMA7vEofZxiqgn8HuKK1Blikur+6XrWnp1MVaC/tNK3BerUIWUPAi0CjFlIMPa62lzDuk4gRxjbJ0UGTigE9xNRlH+NNnaM7Qv/z7GhEwDKBdCnwvsg8COP+ZH62wDDLun8lNWTIDL9Y66IzEsp2g=
Subject: [PATCH 1/3] x86: sparse warning in cpufreq/powernow-k8.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 16:07:47 -0800
Message-Id: <1202342867.5820.89.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nested per_cpu accessors will shadow the internal __ptr variable.  Use
a temporary first_core variable.

arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1239:9: warning: symbol '__ptr' shadows an earlier one
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1239:9: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 5affe91..e64eee0 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1234,9 +1234,10 @@ static unsigned int powernowk8_get (unsigned int cpu)
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask = current->cpus_allowed;
+	unsigned int first_core = first_cpu(per_cpu(cpu_core_map, cpu));
 	unsigned int khz = 0;
 
-	data = per_cpu(powernow_data, first_cpu(per_cpu(cpu_core_map, cpu)));
+	data = per_cpu(powernow_data, first_core);
 
 	if (!data)
 		return -EINVAL;
-- 
1.5.4.1189.g38fd5


