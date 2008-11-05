Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYKET7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYKET7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbYKET6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:58:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41407 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbYKET6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:58:01 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
Date: Wed,  5 Nov 2008 17:56:58 -0200
Message-Id: <1225915018-6548-16-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit c7ffa6c26277b403920e2255d10df849bd613380.

Now that we have the hooks to disable virtualization on
emergency_restart(), we can get back to the BOOT_KBD reboot_type default.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/reboot.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 3240491..260c131 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -32,11 +32,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-/*
- * Keyboard reset and triple fault may result in INIT, not RESET, which
- * doesn't work when we're in vmx root mode.  Try ACPI first.
- */
-enum reboot_type reboot_type = BOOT_ACPI;
+enum reboot_type reboot_type = BOOT_KBD;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
-- 
1.5.5.GIT

