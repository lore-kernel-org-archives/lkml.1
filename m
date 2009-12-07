Return-Path: <linux-kernel-owner+w=401wt.eu-S934778AbZLGMTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778AbZLGMTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934723AbZLGMTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:19:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:37191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934721AbZLGMTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:19:31 -0500
Date: Mon, 7 Dec 2009 12:18:37 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain>
References: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix bogus warning in apic_noop.apic_write()
Message-ID: <tip-a946d8f11f0da9cfc714248036fcfd3a794d1e27@git.kernel.org>
Git-Commit-ID: a946d8f11f0da9cfc714248036fcfd3a794d1e27
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a946d8f11f0da9cfc714248036fcfd3a794d1e27
Gitweb:     http://git.kernel.org/tip/a946d8f11f0da9cfc714248036fcfd3a794d1e27
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 7 Dec 2009 12:59:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 13:16:37 +0100

x86: Fix bogus warning in apic_noop.apic_write()

apic_noop is used to provide dummy apic functions. It's installed
when the CPU has no APIC or when the APIC is disabled on the kernel
command line.

The apic_noop implementation of apic_write() warns when the CPU has
an APIC or when the APIC is not disabled.

That's bogus. The warning should only happen when the CPU has an
APIC _AND_ the APIC is not disabled. apic_noop.apic_read() has the
correct check.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: <stable@kernel.org> # in <= .32 this typo resides in native_apic_write_dummy()
LKML-Reference: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic_noop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index d9acc3b..e31b9ff 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -127,7 +127,7 @@ static u32 noop_apic_read(u32 reg)
 
 static void noop_apic_write(u32 reg, u32 v)
 {
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
 }
 
 struct apic apic_noop = {
