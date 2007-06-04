Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbXFDLRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbXFDLRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbXFDLRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:17:33 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46775 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbXFDLRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:17:32 -0400
X-Originating-Ip: 72.143.65.211
Date: Mon, 4 Jun 2007 07:15:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove apparently useless, commented apm_get_battery_status().
Message-ID: <Pine.LNX.4.64.0706040715520.32191@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the "#if 0"ed definition of apm_get_battery_status().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

---

diff --git a/arch/i386/kernel/apm.c b/arch/i386/kernel/apm.c
index 4112afe..5c6da2b 100644
--- a/arch/i386/kernel/apm.c
+++ b/arch/i386/kernel/apm.c
@@ -1006,35 +1006,6 @@ static int apm_get_power_status(u_short *status, u_short *bat, u_short *life)
 	return APM_SUCCESS;
 }

-#if 0
-static int apm_get_battery_status(u_short which, u_short *status,
-				  u_short *bat, u_short *life, u_short *nbat)
-{
-	u32	eax;
-	u32	ebx;
-	u32	ecx;
-	u32	edx;
-	u32	esi;
-
-	if (apm_info.connection_version < 0x0102) {
-		/* pretend we only have one battery. */
-		if (which != 1)
-			return APM_BAD_DEVICE;
-		*nbat = 1;
-		return apm_get_power_status(status, bat, life);
-	}
-
-	if (apm_bios_call(APM_FUNC_GET_STATUS, (0x8000 | (which)), 0, &eax,
-			&ebx, &ecx, &edx, &esi))
-		return (eax >> 8) & 0xff;
-	*status = ebx;
-	*bat = ecx;
-	*life = edx;
-	*nbat = esi;
-	return APM_SUCCESS;
-}
-#endif
-
 /**
  *	apm_engage_power_management	-	enable PM on a device
  *	@device: identity of device
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
