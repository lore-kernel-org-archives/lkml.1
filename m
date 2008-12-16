Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbYLPUcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbYLPUcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbYLPUc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:32:29 -0500
Received: from gw.goop.org ([64.81.55.164]:57988 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYLPUc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:32:28 -0500
Message-ID: <49481057.2030307@goop.org>
Date: Tue, 16 Dec 2008 12:32:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make sure we really have an hpet mapping before using
 it
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting in Xen dom0, the hpet isn't really accessible, so make
sure the mapping is non-NULL before use.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/hpet.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -818,9 +818,10 @@
 
 		hpet_address = force_hpet_address;
 		hpet_enable();
-		if (!hpet_virt_address)
-			return -ENODEV;
 	}
+
+	if (!hpet_virt_address)
+		return -ENODEV;
 
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 


