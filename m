Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbZA2KKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbZA2KKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZA2KKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:10:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:17802 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZA2KKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:10:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lkPGB+rmBs58Pd4HSFkl7C7jbaLEiubLGIB2+n31gsbI5WPVZBQcS4tMpSB9U/jjgh
         fs4ZQNwx5wALDy3xVLljzRuRIc84DIipq7so43kzwanwWOw8nhK2QV2szQgkHS1d5zf9
         wtvfTFB1d0aPtqJ6Hs6ywuSqhnEEyeC7XawgI=
Date: Thu, 29 Jan 2009 13:16:04 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, len.brown@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] eeepc: should depend on INPUT
Message-ID: <20090129101604.GA4425@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise with INPUT=m, EEEPC_LAPTOP=y one gets

drivers/built-in.o: In function `input_sync':
eeepc-laptop.c:(.text+0x18ce51): undefined reference to `input_event'
drivers/built-in.o: In function `input_report_key':
eeepc-laptop.c:(.text+0x18ce73): undefined reference to `input_event'
drivers/built-in.o: In function `eeepc_hotk_check':
eeepc-laptop.c:(.text+0x18d05f): undefined reference to `input_allocate_device'
eeepc-laptop.c:(.text+0x18d10f): undefined reference to `input_register_device'
eeepc-laptop.c:(.text+0x18d131): undefined reference to `input_free_device'
drivers/built-in.o: In function `eeepc_backlight_exit':
eeepc-laptop.c:(.text+0x18d546): undefined reference to `input_unregister_device'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -300,6 +300,7 @@ config INTEL_MENLOW
 config EEEPC_LAPTOP
 	tristate "Eee PC Hotkey Driver (EXPERIMENTAL)"
 	depends on ACPI
+	depends on INPUT
 	depends on EXPERIMENTAL
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
