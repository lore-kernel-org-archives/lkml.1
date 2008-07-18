Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYGRRux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYGRRux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbYGRRuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:50:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:51743 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760164AbYGRRuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:50:13 -0400
Message-ID: <4880D7D0.9040200@windriver.com>
Date: Fri, 18 Jul 2008 12:50:08 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 2/3] kgdb, mips: add arch support for the kernel's kgdb
 core
References: <1216400928-29097-1-git-send-email-jason.wessel@windriver.com><1216400928-29097-2-git-send-email-jason.wessel@windriver.com><1216400928-29097-3-git-send-email-jason.wessel@windriver.com> <20080719.023116.122828931.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080719.023116.122828931.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jul 2008 17:50:04.0010 (UTC) FILETIME=[B53D74A0:01C8E8FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> 
> The kgdb_ealy_setup check should be at beginning of init_IRQ (before
> set_irq_noprobe loop)?


I would agree, and it looks like the following now in the patch.
I will revalidate with the HW to ensure there is no regression. :-)

Jason.

@@ -130,8 +135,18 @@ void __init init_IRQ(void)
 {
 	int i;
 
+#ifdef CONFIG_KGDB
+	if (kgdb_early_setup)
+		return;
+#endif
+
 	for (i = 0; i < NR_IRQS; i++)
 		set_irq_noprobe(i);
 
 	arch_init_irq();
+
+#ifdef CONFIG_KGDB
+	if (!kgdb_early_setup)
+		kgdb_early_setup = 1;
+#endif
 }
