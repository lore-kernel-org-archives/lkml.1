Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbYGJRFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbYGJRFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYGJREx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:04:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbYGJREw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:04:52 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH] remove duplicate call to use_tsc_delay.
Date: Thu, 10 Jul 2008 14:01:47 -0300
Message-Id: <1215709307-13558-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integration generated a duplicate call to use_tsc_delay.
Particularly, the one that is done before we check for general
tsc usability seems wrong.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/tsc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 4a775d0..3c36f92 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -513,7 +513,6 @@ void __init tsc_init(void)
 	 */
 	for_each_possible_cpu(cpu)
 		set_cyc2ns_scale(cpu_khz, cpu);
-	use_tsc_delay();
 
 	if (tsc_disabled > 0)
 		return;
-- 
1.5.5.1

