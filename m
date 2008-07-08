Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYGHXRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYGHXRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbYGHXOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:43 -0400
Received: from gw.goop.org ([64.81.55.164]:51207 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806AbYGHXOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 55] xen: print backtrace on multicall failure
X-Mercurial-Node: f6fe1b241a8240cb88d782d70c7cb605d4bae18b
Message-Id: <f6fe1b241a8240cb88d7.1215554790@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print a backtrace if a multicall fails, to help with debugging.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/multicalls.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -76,6 +76,7 @@
 		if (ret) {
 			printk(KERN_ERR "%d multicall(s) failed: cpu %d\n",
 			       ret, smp_processor_id());
+			dump_stack();
 			for (i = 0; i < b->mcidx; i++) {
 				printk("  call %2d/%d: op=%lu arg=[%lx] result=%ld\n",
 				       i+1, b->mcidx,


