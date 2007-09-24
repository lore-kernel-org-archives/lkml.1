Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbXIXRt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbXIXRt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXIXRts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:49:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37789 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267AbXIXRtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:49:47 -0400
Date: Mon, 24 Sep 2007 10:49:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jonathan Campbell <jon@nerdgrounds.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel
 2.6.22.7
Message-Id: <20070924104940.50a52cf3.randy.dunlap@oracle.com>
In-Reply-To: <46F77A85.6020202@nerdgrounds.com>
References: <46F77A85.6020202@nerdgrounds.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 01:51:17 -0700 Jonathan Campbell wrote:

> Sorry for the long delay, been very busy since I last posted the 386 
> kernel patches back in July.
> Now that I have more free time I remade the patches in a cleaner manner, 
> broken down into
> smaller patches, with fewer #ifdefs all over the place. most #ifdefs are 
> in the include/asm-i386 headers
> now.

Regarding only the DMI-disable patch:

> linux-2.6.22.7-embedded-dmi-disable-option.patch:
>     * Allows you to remove DMI (Desktop Management Interface) parsing. 
> Older computers do
>        not have DMI structures in the BIOS, on these computers the DMI 
> code is a waste of space.
>        In my tests with applying this patch and disabling DMI removes 
> 6KB from
>        arch/i386/boot/bzImage after compile. Apparently there is already 
> a CONFIG_DMI out there,
>        and #ifdef's in some parts to check this, so all this patch does 
> is make CONFIG_DMI visible
>        from "make menuconfig" while patching up other parts (like ACPI) 
> that simply assume DMI
>        functions are there. Depends on CONFIG_EMBEDDED.


This seems reasonable, so I tried to use it.  Here are the results
and comments and meta-comments.


1.  Please forcibly wrap text lines in mail body at around column 70-72.

2.  Put patches inline in the mail body, not as attachments.

3.  Make patches against current mainline (e.g., 2.6.23-rc7), not
    against the stable tree.  Mainline is where someone would end
    up applying them.

4.  The DMI patch does not build against current mainline.  It needs
    the additional patch below (at end of mail).

5.  The Kconfig part of the DMI patch contains a trailing space.
    No brownie today.

6.  The Kconfig entry for "config DMI" should not be listed under
    "Processor types and features".  It should just go into the
    main EMBEDDED menu:

menuconfig EMBEDDED
	bool "Configure standard kernel features (for small systems)"


After all of these fixes, I can ack the patch.

---

From: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/acpi/thermal.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.23-rc7.orig/drivers/acpi/thermal.c
+++ linux-2.6.23-rc7/drivers/acpi/thermal.c
@@ -1440,7 +1440,9 @@ static int __init acpi_thermal_init(void
 {
 	int result = 0;
 
+#ifdef CONFIG_DMI
 	dmi_check_system(thermal_dmi_table);
+#endif /* CONFIG_DMI */
 
 	if (off) {
 		printk(KERN_NOTICE "ACPI: thermal control disabled\n");
