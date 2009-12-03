Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZLCLHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZLCLHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZLCLHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:07:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZLCLHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:07:07 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -tip] x86/trivial: add pci_dev_put in reboot_fixup_32.c for consistency
Date: Thu,  3 Dec 2009 19:06:40 +0800
Message-Id: <1259838400-23833-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <20091203104056.GB7628@elte.hu>
References: <20091203104056.GB7628@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_get_device will increase the ref count of found device.
Although we're going to reset soon, we should use pci_dev_put
to decrease the ref count for consistency.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
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
1.5.5.6

