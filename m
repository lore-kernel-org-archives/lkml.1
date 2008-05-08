Return-Path: <linux-kernel-owner+w=401wt.eu-S1764348AbYEHUKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764348AbYEHUKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbYEHUK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:10:27 -0400
Received: from baikonur.stro.at ([213.239.196.228]:47364 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbYEHUK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:10:26 -0400
From: maximilian attems <max@stro.at>
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       maximilian attems <max@stro.at>, Kaz Sasayama <kazssym@hypercore.co.jp>
Subject: [PATCH] Crusoe: longrun cpufreq module reports false min freq
Date: Thu,  8 May 2008 22:10:01 +0200
Message-Id: <1210277401-14288-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The longrun cpufreq module reports a false minimum frequency 3MHz on
300-600MHz Crusoe processor.  This may be due to a calculation bug
in the module.

Original patch from Kaz Sasayama <kazssym@hypercore.co.jp>
submitted as http://bugs.debian.org/468149 patch ported to x86

Cc: Kaz Sasayama <kazssym@hypercore.co.jp>
Signed-off-by: maximilian attems <max@stro.at>
---
 arch/x86/kernel/cpu/cpufreq/longrun.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/longrun.c b/arch/x86/kernel/cpu/cpufreq/longrun.c
index af4a867..777a7ff 100644
--- a/arch/x86/kernel/cpu/cpufreq/longrun.c
+++ b/arch/x86/kernel/cpu/cpufreq/longrun.c
@@ -245,7 +245,7 @@ static unsigned int __init longrun_determine_freqs(unsigned int *low_freq,
 	if ((ecx > 95) || (ecx == 0) || (eax < ebx))
 		return -EIO;
 
-	edx = (eax - ebx) / (100 - ecx);
+	edx = ((eax - ebx) * 100) / (100 - ecx);
 	*low_freq = edx * 1000; /* back to kHz */
 
 	dprintk("low frequency is %u kHz\n", *low_freq);
-- 
1.5.5.1

