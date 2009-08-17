Return-Path: <linux-kernel-owner+w=401wt.eu-S932557AbZHQLyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbZHQLyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932366AbZHQLyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:54:38 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:41019 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333AbZHQLyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:54:35 -0400
Message-Id: <4A8961170200007800010117@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 17 Aug 2009 12:54:31 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Greg Kroah-Hartman" <GregKH@novell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] adjust Hyper-V Kconfig
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hyper-V sub-components' options should all depend on the base option.

The default of these sub-component options is also more reasonably set
to that of the base option (since it makes little sense to enable the
base option without the sub-component ones).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-next/drivers/staging/hv/Kconfig
+++ linux-next/drivers/staging/hv/Kconfig
@@ -6,23 +6,27 @@
 	  Select this option to run Linux as a Hyper-V client operating
 	  system.

+if HYPERV
+
 config HYPERV_STORAGE
 	tristate "Microsoft Hyper-V virtual storage driver"
-	depends on SCSI && m
-	default n
+	depends on SCSI
+	default HYPERV
 	help
 	 Select this option to enable the Hyper-V virtual storage driver.
 
 config HYPERV_BLOCK
 	tristate "Microsoft Hyper-V virtual block driver"
-	depends on BLOCK && SCSI && m
-	default n
+	depends on BLOCK && SCSI
+	default HYPERV
 	help
 	  Select this option to enable the Hyper-V virtual block driver.
 
 config HYPERV_NET
 	tristate "Microsoft Hyper-V virtual network driver"
-	depends on NET && m
-	default n
+	depends on NET
+	default HYPERV
 	help
 	  Select this option to enable the Hyper-V virtual network driver.
+
+endif



