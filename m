Return-Path: <linux-kernel-owner+w=401wt.eu-S1761289AbZCMRJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289AbZCMRJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760017AbZCMRBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:40 -0400
Received: from gw.goop.org ([64.81.55.164]:57436 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759905AbZCMRBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:39 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 19/27] xen: set callout_map to make mtrr work
Date: Fri, 13 Mar 2009 10:00:04 -0700
Message-Id: <1236963612-14287-20-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

It needs it for its cross-cpu mtrr setup handshake.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/smp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 304d832..dc9cd85 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -210,6 +210,7 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 		if (IS_ERR(idle))
 			panic("failed fork for CPU %d", cpu);
 
+		cpumask_set_cpu(cpu, cpu_callout_mask);
 		cpu_set(cpu, cpu_present_map);
 	}
 }
-- 
1.6.0.6

