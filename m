Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbZKFWwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbZKFWwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbZKFWwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:52:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:52906 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577AbZKFWwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:52:02 -0500
Date: Fri, 6 Nov 2009 22:51:47 GMT
From: tip-bot for Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       simon.kagstrom@netinsight.net, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, simon.kagstrom@netinsight.net
In-Reply-To: <20091106154404.002648d9@marrow.netinsight.se>
References: <20091106154404.002648d9@marrow.netinsight.se>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Add Phoenix/MSC BIOSes to lowmem corruption list
Message-ID: <tip-f1b291d4c47440cbfc1a478e88800e2742d60a80@git.kernel.org>
Git-Commit-ID: f1b291d4c47440cbfc1a478e88800e2742d60a80
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1b291d4c47440cbfc1a478e88800e2742d60a80
Gitweb:     http://git.kernel.org/tip/f1b291d4c47440cbfc1a478e88800e2742d60a80
Author:     Simon Kagstrom <simon.kagstrom@netinsight.net>
AuthorDate: Fri, 6 Nov 2009 15:44:04 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 6 Nov 2009 14:49:39 -0800

x86: Add Phoenix/MSC BIOSes to lowmem corruption list

We have a board with a Phoenix/MSC BIOS which also corrupts the low
64KB of RAM, so add an entry to the table.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
LKML-Reference: <20091106154404.002648d9@marrow.netinsight.se>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/setup.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e09f0e2..2a34f9c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -660,6 +660,13 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 		},
 	},
 	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "Phoenix/MSC BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix/MSC"),
+		},
+	},
+	{
 	/*
 	 * AMI BIOS with low memory corruption was found on Intel DG45ID board.
 	 * It hase different DMI_BIOS_VENDOR = "Intel Corp.", for now we will
