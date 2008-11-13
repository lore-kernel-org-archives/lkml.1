Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYKMTg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYKMTg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYKMTeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:12 -0500
Received: from gw.goop.org ([64.81.55.164]:34395 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYKMTeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:04 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 38] x86: make sure we really have an hpet mapping before
	using it
X-Mercurial-Node: 8bd4ede9acc724947e7ca15f9b527c3ce6e6b1ee
Message-Id: <8bd4ede9acc724947e7c.1226603407@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting in Xen dom0, the hpet isn't really accessible, so make
sure the mapping is non-NULL before use.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/hpet.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -834,10 +834,11 @@
 
 		hpet_address = force_hpet_address;
 		hpet_enable();
-		if (!hpet_virt_address)
-			return -ENODEV;
 	}
 
+	if (!hpet_virt_address)
+		return -ENODEV;
+
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 
 	for_each_online_cpu(cpu) {


