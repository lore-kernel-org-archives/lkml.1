Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbXEaU2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbXEaU2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbXEaU2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:28:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39476 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbXEaU2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:28:03 -0400
Date: Thu, 31 May 2007 22:29:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Prarit Bhargava <prarit@redhat.com>, len.brown@intel.com
Cc: Christoph Lameter <clameter@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: [PATCH] acpi: fix section mismatch warning in asus + toshiba
Message-ID: <20070531202903.GE27305@uranus.ravnborg.org>
References: <617E1C2C70743745A92448908E030B2A01929DD3@scsmsx411.amr.corp.intel.com> <Pine.LNX.4.64.0705302019040.5583@schroedinger.engr.sgi.com> <465EE7BB.4050605@redhat.com> <20070531200446.GA27305@uranus.ravnborg.org> <20070531202440.GD27305@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531202440.GD27305@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following section mismatch warnings in acpi

WARNING: drivers/acpi/asus_acpi.o(.init.text+0xb7): Section mismatch: reference to .exit.text: (after 'init_module')
WARNING: o-i386/drivers/acpi/toshiba_acpi.o(.init.text+0x13a): Section mismatch: reference to .exit.text: (after 'init_module')

The exit function is used in the init function during an error codition.
As __exit may be discarded during link-time / run-time this is no good.
Do not mark the exit function __exit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
Updated patch that covers both drivers.

	Sam

diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
index b770dea..6d7d415 100644
--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -1357,7 +1357,7 @@ static struct backlight_ops asus_backlight_data = {
         .update_status  = set_brightness_status,
 };
 
-static void __exit asus_acpi_exit(void)
+static void asus_acpi_exit(void)
 {
 	if (asus_backlight_device)
 		backlight_device_unregister(asus_backlight_device);
diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index 3906d47..1cfbecb 100644
--- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -538,7 +538,7 @@ static struct backlight_ops toshiba_backlight_data = {
         .update_status  = set_lcd_status,
 };
 
-static void __exit toshiba_acpi_exit(void)
+static void toshiba_acpi_exit(void)
 {
 	if (toshiba_backlight_device)
 		backlight_device_unregister(toshiba_backlight_device);
