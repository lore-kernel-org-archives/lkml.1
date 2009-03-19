Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZCSIWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZCSIWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZCSIWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 04:22:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:60076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZCSIV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 04:21:59 -0400
Date: Thu, 19 Mar 2009 08:21:26 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, jaswinderrajput@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       jaswinderrajput@gmail.com
In-Reply-To: <1237403503.22438.21.camel@ht.satnam>
References: <1237403503.22438.21.camel@ht.satnam>
Subject: [tip:x86/cleanups] x86: mpparse: clean up code by introducing a few helper functions, fix
Message-ID: <tip-c58603e81b3ed4f1c7352e091fe43fd0bd8d06cc@git.kernel.org>
Git-Commit-ID: c58603e81b3ed4f1c7352e091fe43fd0bd8d06cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Mar 2009 08:21:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c58603e81b3ed4f1c7352e091fe43fd0bd8d06cc
Gitweb:     http://git.kernel.org/tip/c58603e81b3ed4f1c7352e091fe43fd0bd8d06cc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 19 Mar 2009 08:50:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Mar 2009 08:52:13 +0100

x86: mpparse: clean up code by introducing a few helper functions, fix

Impact: fix boot crash

This fixes commit a6830278568a8bb9758aac152db15187741e0113.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1237403503.22438.21.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/mpparse.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 58ddf62..290cb57 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -319,23 +319,23 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 		case MP_PROCESSOR:
 			/* ACPI may have already provided this data */
 			if (!acpi_lapic)
-				MP_processor_info((struct mpc_cpu *)&mpt);
+				MP_processor_info((struct mpc_cpu *)mpt);
 			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
 			break;
 		case MP_BUS:
-			MP_bus_info((struct mpc_bus *)&mpt);
+			MP_bus_info((struct mpc_bus *)mpt);
 			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
 			break;
 		case MP_IOAPIC:
-			MP_ioapic_info((struct mpc_ioapic *)&mpt);
+			MP_ioapic_info((struct mpc_ioapic *)mpt);
 			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
 			break;
 		case MP_INTSRC:
-			MP_intsrc_info((struct mpc_intsrc *)&mpt);
+			MP_intsrc_info((struct mpc_intsrc *)mpt);
 			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
 			break;
 		case MP_LINTSRC:
-			MP_lintsrc_info((struct mpc_lintsrc *)&mpt);
+			MP_lintsrc_info((struct mpc_lintsrc *)mpt);
 			skip_entry(&mpt, &count, sizeof(struct mpc_lintsrc));
 			break;
 		default:
@@ -902,7 +902,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
 			break;
 		case MP_INTSRC:
-			check_irq_src((struct mpc_intsrc *)&mpt, &nr_m_spare);
+			check_irq_src((struct mpc_intsrc *)mpt, &nr_m_spare);
 			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
 			break;
 		case MP_LINTSRC:
