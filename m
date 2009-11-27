Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZK0DQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZK0DQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 22:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZK0DQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 22:16:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbZK0DQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 22:16:31 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH -tip] x86: reboot_fixup_32.c add missing pci_dev_put
Date: Fri, 27 Nov 2009 11:16:02 +0800
Message-Id: <1259291762-17735-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_get_device increments reference count to the found pci device, that
should be decremented using pci_dev_put.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/reboot_fixups_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index 61a8377..201eab6 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -80,6 +80,7 @@ void mach_reboot_fixups(void)
 			continue;
 
 		cur->reboot_fixup(dev);
+		pci_dev_put(dev);
 	}
 }
 
-- 
1.6.5.2

