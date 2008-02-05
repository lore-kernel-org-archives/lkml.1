Return-Path: <linux-kernel-owner+w=401wt.eu-S1761262AbYBEUlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262AbYBEUlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760981AbYBEUkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:40:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:24457 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057AbYBEUkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:40:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EsxcZBWpUewyKs/52AXlpDf3PTH1ROWm0DF5az4glUyJVSBrJvaWdENghgpRga0y3j8F7TTCnYtioMdvE3HSl/sEoaLuymPLdHdfKGsl1VLi8RFaWQK1H/2qz+h5A8zOqWRV+UL3totP1cDJ/AMqHavd7vBWDmhGNsLylcoVEic=
Subject: [PATCH 2/8] x86: fix sparse warnings in powernow-k8.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 12:40:28 -0800
Message-Id: <1202244028.18081.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse errors from include/linux/cpuidle.h currently are hiding these:

arch/x86/kernel/cpu/cpufreq/powernow-k8.c:830:7: warning: symbol 'hi' shadows an earlier one
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:824:6: originally declared here
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:830:15: warning: symbol 'lo' shadows an earlier one
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:824:14: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index a052273..5affe91 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -827,7 +827,6 @@ static int fill_powernow_table_pstate(struct powernow_k8_data *data, struct cpuf
 
 	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 index;
-		u32 hi = 0, lo = 0;
 
 		index = data->acpi_data.states[i].control & HW_PSTATE_MASK;
 		if (index > data->max_hw_pstate) {
-- 
1.5.4.rc5.1138.g2602


