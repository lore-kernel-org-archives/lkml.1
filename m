Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZCBKTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZCBKTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbZCBKTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:19:34 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:58982 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105AbZCBKTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:19:34 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] x86_32: apic/numaq_32, fix section mismatch
Date: Mon,  2 Mar 2009 11:18:54 +0100
Message-Id: <1235989134-29146-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235989134-29146-1-git-send-email-jirislaby@gmail.com>
References: <1235989134-29146-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove __cpuinitdata section placement for translation_table
structure, since it is referenced from a functions within .text.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/numaq_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index a7f711f..ba2fc64 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -69,7 +69,7 @@ struct mpc_trans {
 /* x86_quirks member */
 static int				mpc_record;
 
-static __cpuinitdata struct mpc_trans	*translation_table[MAX_MPC_ENTRY];
+static struct mpc_trans			*translation_table[MAX_MPC_ENTRY];
 
 int					mp_bus_id_to_node[MAX_MP_BUSSES];
 int					mp_bus_id_to_local[MAX_MP_BUSSES];
-- 
1.6.1.3

