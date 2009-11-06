Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZKFGAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZKFGAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 01:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZKFGAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 01:00:50 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:60562 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbZKFGAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 01:00:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=wOrzk62YRNs+C0tMItJFNfXsPvUOnMR6TlUjuRNvZBgfa7mHwB6tlH5Cf1u412uS8w
         LhBBpxQynsAAHxz8iNFdMVOzuXTfHI7kTRnoBWIN5JDUNo/Qj/WPn3auC6bWVcW2K6Y3
         RPJCKoJHNzdeVL62obW0FRL41WtXZyp9YcUzI=
MIME-Version: 1.0
Date: Fri, 6 Nov 2009 14:00:55 +0800
Message-ID: <2674af740911052200m141e71d5v37d621d23771aa91@mail.gmail.com>
Subject: [PATCH] irq: remove __weak early_irq_init()
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 86a53664e3f503fe06b166fb248ed64a77212b3d Mon Sep 17 00:00:00 2001
From: Yong Zhang <yong.zhang0@gmail.com>
Date: Fri, 6 Nov 2009 13:53:30 +0800
Subject: [PATCH] irq: remove __weak early_irq_init()

impact: cleanup

Since commit 12026ea16a618b289fcf457661aed24f57323a20
early_irq_init() is always defined in kernel/irq/handle.c
So remove the weak definition.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/softirq.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index f8749e5..5e881e3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -886,11 +886,6 @@ EXPORT_SYMBOL(on_each_cpu);
  *   GCC does not inline them incorrectly. ]
  */

-int __init __weak early_irq_init(void)
-{
-	return 0;
-}
-
 int __init __weak arch_probe_nr_irqs(void)
 {
 	return 0;
-- 
1.6.3.3
