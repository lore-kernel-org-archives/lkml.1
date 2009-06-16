Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbZFPGDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbZFPGDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935938AbZFPFvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:41 -0400
Received: from kroah.org ([198.145.64.141]:48462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935916AbZFPFvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 54/64] mips: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:43 -0700
Message-Id: <1245131213-24168-54-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/mips/sni/eisa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/sni/eisa.c b/arch/mips/sni/eisa.c
index 7396cd7..6827feb 100644
--- a/arch/mips/sni/eisa.c
+++ b/arch/mips/sni/eisa.c
@@ -38,7 +38,7 @@ int __init sni_eisa_root_init(void)
 	if (!r)
 		return r;
 
-	eisa_root_dev.dev.driver_data = &eisa_bus_root;
+	dev_set_drvdata(&eisa_root_dev.dev, &eisa_bus_root);
 
 	if (eisa_root_register(&eisa_bus_root)) {
 		/* A real bridge may have been registered before
-- 
1.6.3.2

