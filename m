Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbYCDTOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbYCDTOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765485AbYCDTOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:14:41 -0500
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:13342 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761559AbYCDTOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:14:40 -0500
Date: Tue, 4 Mar 2008 20:12:28 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Mark McLoughlin <markmc@redhat.com>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB, 64-bit, use paravirt_enabled
Message-ID: <20080304191228.GA12403@mailshack.com>
References: <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff> <1204310323.24514.1239870063@webmail.messagingengine.com> <1204322819.6299.1.camel@muff> <20080301160911.GA13271@mailshack.com> <1204631082.16613.7.camel@muff> <47CD6858.9070603@goop.org> <1204649476.5048.1240509149@webmail.messagingengine.com> <47CD82C5.8060605@goop.org> <20080304185742.GA12193@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304185742.GA12193@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Tue, 04 Mar 2008 20:13:27 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.73; VDF: 7.0.2.231; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge pointed out that looking at the boot_params
struct to determine if the system is running in a paravirtual
environment is not reliable for the Xen case, currently. He also
points out that there already exists a function to determine if
the system is running in a paravirtual environment. So let's use
that instead. This gets rid of the preprocessor test too.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Same, for 64 bit.

Greetings,
	Alexander

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 269a6b4..48be76c 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -72,12 +72,8 @@ static void __init reserve_ebda_region(void)
 	/* that area is absent. We'll just have to assume */
 	/* that the paravirt case can handle memory setup */
 	/* correctly, without our help. */
-#ifdef CONFIG_PARAVIRT
-	if ((boot_params.hdr.version >= 0x207) &&
-			(boot_params.hdr.hardware_subarch != 0)) {
+	if (paravirt_enabled())
 		return;
-	}
-#endif
 
 	/* end of low (conventional) memory */
 	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
