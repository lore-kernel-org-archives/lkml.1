Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZHFL6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZHFL6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZHFL6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:58:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:46570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbZHFL6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:58:49 -0400
Date: Thu, 6 Aug 2009 11:57:59 GMT
From: tip-bot for Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, dwmw2@infradead.org,
       benh@kernel.crashing.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       dwmw2@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <19066.48028.446975.501454@cargo.ozlabs.ibm.com>
References: <19066.48028.446975.501454@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/urgent] perf_counter/powerpc: Check oprofile_cpu_type for NULL before using it
Message-ID: <tip-e0d82a0a4e9841b787e6431ccfbb515546c55dc2@git.kernel.org>
Git-Commit-ID: e0d82a0a4e9841b787e6431ccfbb515546c55dc2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 06 Aug 2009 11:58:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0d82a0a4e9841b787e6431ccfbb515546c55dc2
Gitweb:     http://git.kernel.org/tip/e0d82a0a4e9841b787e6431ccfbb515546c55dc2
Author:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
AuthorDate: Thu, 6 Aug 2009 21:16:44 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 6 Aug 2009 13:55:09 +0200

perf_counter/powerpc: Check oprofile_cpu_type for NULL before using it

If the current CPU doesn't support performance counters,
cur_cpu_spec->oprofile_cpu_type can be NULL. The current
perf_counter modules don't test for that case and would thus
crash at boot time.

Bug reported by David Woodhouse.

Reported-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul Mackerras <paulus@samba.org>
LKML-Reference: <19066.48028.446975.501454@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/mpc7450-pmu.c |    3 ++-
 arch/powerpc/kernel/power4-pmu.c  |    3 ++-
 arch/powerpc/kernel/power5+-pmu.c |    5 +++--
 arch/powerpc/kernel/power5-pmu.c  |    3 ++-
 arch/powerpc/kernel/power6-pmu.c  |    3 ++-
 arch/powerpc/kernel/power7-pmu.c  |    3 ++-
 arch/powerpc/kernel/ppc970-pmu.c  |    5 +++--
 7 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/mpc7450-pmu.c b/arch/powerpc/kernel/mpc7450-pmu.c
index c244133..cc466d0 100644
--- a/arch/powerpc/kernel/mpc7450-pmu.c
+++ b/arch/powerpc/kernel/mpc7450-pmu.c
@@ -407,7 +407,8 @@ struct power_pmu mpc7450_pmu = {
 
 static int init_mpc7450_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc/7450"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc/7450"))
 		return -ENODEV;
 
 	return register_power_pmu(&mpc7450_pmu);
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index db90b0c..3c90a3d 100644
--- a/arch/powerpc/kernel/power4-pmu.c
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -606,7 +606,8 @@ static struct power_pmu power4_pmu = {
 
 static int init_power4_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power4"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power4"))
 		return -ENODEV;
 
 	return register_power_pmu(&power4_pmu);
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index f4adca8..31918af 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -678,8 +678,9 @@ static struct power_pmu power5p_pmu = {
 
 static int init_power5p_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5+")
-	    && strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5++"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5+")
+	     && strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5++")))
 		return -ENODEV;
 
 	return register_power_pmu(&power5p_pmu);
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index 29b2c6c..867f6f6 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -618,7 +618,8 @@ static struct power_pmu power5_pmu = {
 
 static int init_power5_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5"))
 		return -ENODEV;
 
 	return register_power_pmu(&power5_pmu);
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index 09ae5bf..fa21890 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -537,7 +537,8 @@ static struct power_pmu power6_pmu = {
 
 static int init_power6_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power6"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power6"))
 		return -ENODEV;
 
 	return register_power_pmu(&power6_pmu);
diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index 5a9f5cb..388cf57 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -366,7 +366,8 @@ static struct power_pmu power7_pmu = {
 
 static int init_power7_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power7"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power7"))
 		return -ENODEV;
 
 	return register_power_pmu(&power7_pmu);
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index 833097a..75dccb7 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -488,8 +488,9 @@ static struct power_pmu ppc970_pmu = {
 
 static int init_ppc970_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/970")
-	    && strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/970MP"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/970")
+	     && strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/970MP")))
 		return -ENODEV;
 
 	return register_power_pmu(&ppc970_pmu);
