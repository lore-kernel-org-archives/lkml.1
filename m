Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZKIJ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZKIJ20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZKIJ2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:28:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:46893 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZKIJ2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:28:24 -0500
Date: Mon, 9 Nov 2009 09:27:44 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, peterz@infradead.org, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, peterz@infradead.org, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20091108131645.GD5300@lenovo>
References: <20091108131645.GD5300@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Get rid of apicid_to_cpu_present assign on 64-bit
Message-ID: <tip-f4a70c55376683213229af7266dc57ad81aee354@git.kernel.org>
Git-Commit-ID: f4a70c55376683213229af7266dc57ad81aee354
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4a70c55376683213229af7266dc57ad81aee354
Gitweb:     http://git.kernel.org/tip/f4a70c55376683213229af7266dc57ad81aee354
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 8 Nov 2009 16:16:45 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 19:46:17 +0100

x86, apic: Get rid of apicid_to_cpu_present assign on 64-bit

In fact it's never get used on x86-64 (for 64 bit platform
we use differ technique to enumerate io-units).

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091108131645.GD5300@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic_noop.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 9ab6ffb..89629f6 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -162,7 +162,12 @@ struct apic apic_noop = {
 
 	.cpu_to_logical_apicid		= noop_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
+
+#ifdef CONFIG_X86_32
 	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
+#else
+	.apicid_to_cpu_present		= NULL,
+#endif
 
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
