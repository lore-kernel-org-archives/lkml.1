Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033Ab0AHTXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab0AHTXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612Ab0AHTXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:23:55 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:44669 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab0AHTXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:23:54 -0500
Date: Fri, 8 Jan 2010 20:23:50 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andy Whitcroft <apw@canonical.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Finn Thain <fthain@telegraphics.com.au>
Subject: checkpatch: EXPORT_SYMBOL() false positive
Message-ID: <alpine.DEB.2.00.1001082021230.7591@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Andy,

A patch from Finn causes a false positive in checkpatch:

| WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
| #13: FILE: arch/m68k/mac/config.c:801:
| +EXPORT_SYMBOL(scc_a_pdev);

Test case from the patch:

--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -792,6 +792,32 @@ static struct mac_model mac_data_table[] = {
 	}
 };
 
+struct platform_device scc_a_pdev = {
+	.name           = "scc",
+	.id             = 0,
+	.num_resources  = ARRAY_SIZE(scc_a_rsrcs),
+	.resource       = scc_a_rsrcs,
+};
+EXPORT_SYMBOL(scc_a_pdev);
+
 static void __init mac_identify(void)
 {

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
