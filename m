Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbZGBP2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbZGBP2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbZGBP1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:27:41 -0400
Received: from ey-out-1920.google.com ([74.125.78.150]:29412 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbZGBP1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DfYCH7v6lZZXcB8kUkxS1IhE/QUC9Zsfxqde8+6eyCVwYfU9WtLQcKA5Jv5YeIHwIY
         lLzcfkL3zGuV20obi3uAmNfP2CdN9mshs3CfXU6g1+He+slIXEdwpL6sg4oQkJOyj3wl
         G2eJGenicxXp4C+rzLPnMQ5uOlzwGigq1j4io=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 06/16] [loongson] pci: use existing mips_io_port_base
Date: Thu,  2 Jul 2009 23:22:11 +0800
Message-Id: <faff7a39cb2be9167f25deb1d505e39a42825c6c.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

mips_io_port_base is initialized via set_io_port_base() in
arch/mips/lemote/lm2e/setup.c, we can use it directly here.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/lemote/lm2e/pci.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/mips/lemote/lm2e/pci.c b/arch/mips/lemote/lm2e/pci.c
index 8be03a8..152efb6 100644
--- a/arch/mips/lemote/lm2e/pci.c
+++ b/arch/mips/lemote/lm2e/pci.c
@@ -84,10 +84,7 @@ static int __init pcibios_init(void)
 {
 	ict_pcimap();
 
-	loongson2e_pci_controller.io_map_base =
-	    (unsigned long) ioremap(LOONGSON2E_IO_PORT_BASE,
-				    loongson2e_pci_io_resource.end -
-				    loongson2e_pci_io_resource.start + 1);
+	loongson2e_pci_controller.io_map_base = mips_io_port_base;
 
 	register_pci_controller(&loongson2e_pci_controller);
 
-- 
1.6.2.1

