Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZFCCzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZFCCzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 22:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZFCCzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 22:55:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48667 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZFCCzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 22:55:43 -0400
Date: Wed, 3 Jun 2009 12:20:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>
Subject: linux-next: manual merge of the wireless tree with the acpi tree
Message-Id: <20090603122046.6aa99d91.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/platform/x86/Kconfig between commit
eedd8dca3c0e6c1fcb5cba11321ea9d69917d85b ("eeepc-laptop: Register as a
pci-hotplug device") from the acpi tree and commit
c6d660ce29295d344fcdc3654274b4a0aad1a9c8 ("rfkill: rewrite") from the
wireless tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/Kconfig
index 58f1c7a,c682ac5..0000000
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@@ -352,10 -337,9 +351,10 @@@ config EEEPC_LAPTO
  	depends on ACPI
  	depends on INPUT
  	depends on EXPERIMENTAL
+ 	depends on RFKILL || RFKILL = n
  	select BACKLIGHT_CLASS_DEVICE
  	select HWMON
- 	select RFKILL
 +	select HOTPLUG_PCI
  	---help---
  	  This driver supports the Fn-Fx keys on Eee PC laptops.
  	  It also adds the ability to switch camera/wlan on/off.
