Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbXIVJaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbXIVJaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXIVJ34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:29:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47443 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXIVJ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:29:56 -0400
Date: Sat, 22 Sep 2007 11:29:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [8/45] x86_64: Use string instruction memcpy on AMD
 Fam11h
In-Reply-To: <20070921204449.6C96B14EFF@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0709221129230.15712@fbirervta.pbzchgretzou.qr>
References: <200709211044.901175000@suse.de> <20070921204449.6C96B14EFF@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 21 2007 22:44, Andi Kleen wrote:
>Subject: [PATCH] [8/45] x86_64: Use string instruction memcpy on AMD Fam11h
>
>--- linux.orig/arch/x86_64/kernel/setup.c
>+++ linux/arch/x86_64/kernel/setup.c
>@@ -575,7 +575,7 @@ static void __cpuinit init_amd(struct cp
> 	level = cpuid_eax(1);
> 	if (c->x86 == 15 && ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58))
> 		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);
>-	if (c->x86 == 0x10)
>+	if (c->x86 == 0x10 || c->x86 == 0x11)
> 		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);

Perhaps it can be assumed that all future CPU versions have this and
	if (c->x86 >= 0x10)
could be used?

