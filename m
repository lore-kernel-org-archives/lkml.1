Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbXFTLzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbXFTLzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXFTLzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:55:11 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:27619
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829AbXFTLzK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:55:10 -0400
Message-Id: <467931E0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 20 Jun 2007 12:55:44 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <torvalds@osdl.org>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [patches] [PATCH for 2.6.22] [9/10] i386: Disable
	alternative()patching after boot with DEBUG_RO
References: <200706201223.443613000@suse.de>
 <20070620102338.18BF914AD0@wotan.suse.de>
In-Reply-To: <20070620102338.18BF914AD0@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 20.06.07 12:23 >>>
>
>Kernel text is protected now so this won't work.
>
>We'll fix it better next time.
>
>Signed-off-by: Andi Kleen <ak@suse.de>
>
>---
> arch/i386/kernel/alternative.c |    5 +++++
> 1 file changed, 5 insertions(+)
>
>Index: linux/arch/i386/kernel/alternative.c
>===================================================================
>--- linux.orig/arch/i386/kernel/alternative.c
>+++ linux/arch/i386/kernel/alternative.c
>@@ -308,6 +308,11 @@ void alternatives_smp_switch(int smp)
> 	printk("lockdep: not fixing up alternatives.\n");
> 	return;
> #endif
>+#ifdef CONFIG_DEBUG_RODATA
>+	/* To be fixed properly post 2.6.22 -- need to get writable
>+ 	   mappings of the kernel text */
>+	return;
>+#endif
> 
> 	if (noreplace_smp || smp_alt_once)
> 		return;

Why would we need this? mark_rodata_ro() already accounts for the
CONFIG_HOTPLUG_CPU case in that it doesn't write protect .text then.

Jan

