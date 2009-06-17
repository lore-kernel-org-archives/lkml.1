Return-Path: <linux-kernel-owner+w=401wt.eu-S1765882AbZFQN5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765882AbZFQN5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbZFQN5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:57:47 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:48303 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZFQN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WERgSd1lvxUiHrAVXM/56Ox0PCEyYQa1rKiVHih0YF5KiKzrUkmbMeSLNgw153Y/P8
         sxFFYCsG4GrUaL6axvjG07XYZhgN8fp6AtyKaAQbU5vWcPltc+3SlYnWYqoRZnJaHjTS
         XmLwB5nFrUSoVWeqABY1m4HB4y0vZzFGxUAnA=
Subject: [PATCH]x86-tsc.c : fix compile warning
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Jun 2009 21:57:37 +0800
Message-Id: <1245247057.3312.2.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix compile warning:
arch/x86/kernel/tsc.c: In function ‘time_cpufreq_notifier’:
arch/x86/kernel/tsc.c:635: warning: ‘dummy’ may be used uninitialized in
this function

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---  
arch/x86/kernel/tsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ae3180c..e65492a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -632,7 +632,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				void *data)
 {
 	struct cpufreq_freqs *freq = data;
-	unsigned long *lpj, dummy;
+	unsigned long *lpj, dummy = 0;
 
 	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
 		return 0;


