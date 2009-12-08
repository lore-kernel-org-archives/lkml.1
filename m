Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZLHHxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZLHHxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:53:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZLHHxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:53:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41522 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZLHHxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:53:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B1E05CC.4040703@jp.fujitsu.com>
Date: Tue, 08 Dec 2009 16:52:44 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86, mce: fix wrong change in mce_create_device
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit cebe182033f156b430952370fb0f9dbe6e89b081 had an unnecessary,
wrong change.  Fix it.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a96e5cd..a8aacd4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1929,7 +1929,7 @@ error2:
 		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[j].attr);
 error:
 	while (--i >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[i].attr);
+		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
 
 	sysdev_unregister(&per_cpu(mce_dev, cpu));
 
-- 
1.6.5.5

