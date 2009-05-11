Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbZEKJzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbZEKJzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbZEKJyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:54:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:53878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950AbZEKJx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:53:58 -0400
Date: Mon, 11 May 2009 09:53:21 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:x86/apic] x86: apic: Check rev 3 fadt correctly for physical_apic bit
Message-ID: <tip-61fe91e1319556f32bebfd7ed2c68ef02e2c17f7@git.kernel.org>
Git-Commit-ID: 61fe91e1319556f32bebfd7ed2c68ef02e2c17f7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:53:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61fe91e1319556f32bebfd7ed2c68ef02e2c17f7
Gitweb:     http://git.kernel.org/tip/61fe91e1319556f32bebfd7ed2c68ef02e2c17f7
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 9 May 2009 23:47:42 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 10:52:40 +0200

x86: apic: Check rev 3 fadt correctly for physical_apic bit

Impact: fix fadt version checking

FADT2_REVISION_ID has value 3 aka rev 3 FADT. So need to use >= instead
of >, as other places in the code do.

[ Impact: extend scope of APIC boot quirk ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic_flat_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 306e5e8..744e6d8 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -235,7 +235,7 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	 * regardless of how many processors are present (x86_64 ES7000
 	 * is an example).
 	 */
-	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
+	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
 		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
 		printk(KERN_DEBUG "system APIC only can use physical flat");
 		return 1;
