Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZLCNYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZLCNYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbZLCNYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:24:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:32935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbZLCNYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:24:20 -0500
Date: Thu, 3 Dec 2009 13:23:40 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
In-Reply-To: <1259838400-23833-1-git-send-email-dfeng@redhat.com>
References: <1259838400-23833-1-git-send-email-dfeng@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] x86/reboot: Add pci_dev_put in reboot_fixup_32.c for consistency
Message-ID: <tip-57fea8f7ab67ef42b7f84999e49e47f8717a2d5b@git.kernel.org>
Git-Commit-ID: 57fea8f7ab67ef42b7f84999e49e47f8717a2d5b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57fea8f7ab67ef42b7f84999e49e47f8717a2d5b
Gitweb:     http://git.kernel.org/tip/57fea8f7ab67ef42b7f84999e49e47f8717a2d5b
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Thu, 3 Dec 2009 19:06:40 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Dec 2009 12:17:55 +0100

x86/reboot: Add pci_dev_put in reboot_fixup_32.c for consistency

pci_get_device will increase the ref count of found device.
Although we're going to reset soon, we should use pci_dev_put
to decrease the ref count for consistency.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1259838400-23833-1-git-send-email-dfeng@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
