Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYGSWdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYGSWdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 18:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYGSWc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 18:32:58 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:34484 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbYGSWc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 18:32:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
	b=nFKC4xFWD/cnkFXqULOyQfEkEUdXMdrHxgiSteHBO1wrYUjDtxGvMgUbqXA4FJCYV4EiAOa/IesTiuSTtxyN7DA37Z4ChXHzaohvu8dHJScnW8zaMstPrA11wXf92+2J;
Message-ID: <48826B96.1070900@simon.arlott.org.uk>
Date: Sat, 19 Jul 2008 23:32:54 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080706)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: mingo@redhat.com
Subject: [PATCH] x86: Add unknown_nmi_panic kernel parameter
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not possible to enable the unknown_nmi_panic sysctl option
until init is run. It's useful to be able to panic the kernel
during boot too, this adds a parameter to enable this option.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/kernel/nmi.c               |    7 +++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 09ad745..06fbb3a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2158,6 +2158,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			Note that genuine overcurrent events won't be
 			reported either.
 
+	unknown_nmi_panic
+			[X86-32,X86-64]
+			Set unknown_nmi_panic=1 early on boot.
+
 	usbcore.autosuspend=
 			[USB] The autosuspend time delay (in seconds) used
 			for newly-detected USB devices (default 2).  This
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index ec024b3..e0b44b7 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -448,6 +448,13 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 
 #ifdef CONFIG_SYSCTL
 
+static int __init setup_unknown_nmi_panic(char *str)
+{
+	unknown_nmi_panic = 1;
+	return 1;
+}
+__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
+
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
 {
 	unsigned char reason = get_nmi_reason();
-- 
1.5.6.2

-- 
Simon Arlott
