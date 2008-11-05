Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYKEUA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYKEUA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbYKET6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:58:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41436 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756987AbYKET6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:58:08 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 08/15] x86: Disable IRQs before doing anything on nmi_shootdown_cpus()
Date: Wed,  5 Nov 2008 17:56:51 -0200
Message-Id: <1225915018-6548-9-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to know on which CPU we are running on, and we don't want to be
preempted while doing this.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/reboot.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 23a9d78..407106e 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -577,6 +577,7 @@ static struct notifier_block crash_nmi_nb = {
 void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 {
 	unsigned long msecs;
+	local_irq_disable();
 
 	/* Make a note of crashing cpu. Will be used in NMI callback.*/
 	crashing_cpu = safe_smp_processor_id();
-- 
1.5.5.GIT

