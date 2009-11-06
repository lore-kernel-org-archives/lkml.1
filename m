Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbZKFOoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbZKFOoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 09:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbZKFOoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 09:44:09 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:47824 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757491AbZKFOoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 09:44:08 -0500
Date: Fri, 6 Nov 2009 15:44:04 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Subject: [PATCH] x86: Workaround low-memory corruption by Phoenix/MSC BIOSes
Message-ID: <20091106154404.002648d9@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a board with a Phoenix/MSC BIOS which also corrupts the low
64KB of RAM, so add an entry to the table.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
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
-- 
1.6.0.4

