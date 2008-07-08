Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYGHXYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYGHXYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbYGHXO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:59 -0400
Received: from gw.goop.org ([64.81.55.164]:51227 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012AbYGHXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 34 of 55] xen: set num_processors
X-Mercurial-Node: 7f9eedd57c16afe663e6f59e7e2883a1b67980a2
Message-Id: <7f9eedd57c16afe663e6.1215554816@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Someone's got to do it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/smp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -155,8 +155,10 @@
 
 	for (i = 0; i < NR_CPUS; i++) {
 		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
-		if (rc >= 0)
+		if (rc >= 0) {
+			num_processors++;
 			cpu_set(i, cpu_possible_map);
+		}
 	}
 }
 


