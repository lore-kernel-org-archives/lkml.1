Return-Path: <linux-kernel-owner+w=401wt.eu-S1765638AbXLMV7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765638AbXLMV7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933152AbXLMV7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:59:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069AbXLMV7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:59:13 -0500
Date: Thu, 13 Dec 2007 16:59:11 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Subject: Fix implicit declaration in via-pmu.c
Message-ID: <20071213215911.GA8591@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/macintosh/via-pmu.c: In function 'register_pmu_pm_ops':
drivers/macintosh/via-pmu.c:2481: error: implicit declaration of function 'pm_set_ops'

Signed-off-by Dave Jones <davej@redhat.com>

--- linux-2.6.23.noarch/drivers/macintosh/via-pmu.c~	2007-11-07 16:54:46.000000000 -0500
+++ linux-2.6.23.noarch/drivers/macintosh/via-pmu.c	2007-11-07 16:55:02.000000000 -0500
@@ -2469,7 +2469,7 @@ static int pmu_sleep_valid(suspend_state
 		&& (pmac_call_feature(PMAC_FTR_SLEEP_STATE, NULL, 0, -1) >= 0);
 }
 
-static struct pm_ops pmu_pm_ops = {
+static struct platform_suspend_ops pmu_pm_ops = {
 	.prepare = powerbook_prepare_sleep,
 	.enter = powerbook_sleep,
 	.finish = powerbook_finish_sleep,
@@ -2478,7 +2478,7 @@ static struct pm_ops pmu_pm_ops = {
 
 static int register_pmu_pm_ops(void)
 {
-	pm_set_ops(&pmu_pm_ops);
+	suspend_set_ops(&pmu_pm_ops);
 
 	return 0;
 }


-- 
http://www.codemonkey.org.uk
