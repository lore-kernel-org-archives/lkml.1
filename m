Return-Path: <linux-kernel-owner+w=401wt.eu-S938961AbXGUQDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938961AbXGUQDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 12:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761923AbXGUQD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 12:03:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52685 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761185AbXGUQD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 12:03:28 -0400
Date: Sat, 21 Jul 2007 18:03:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: [PATCH] Use descriptor's functions instead of inline assembly
In-Reply-To: <1184939761.16311.22.camel@t60>
Message-ID: <Pine.LNX.4.64.0707211802050.21737@fbirervta.pbzchgretzou.qr>
References: <1184939761.16311.22.camel@t60>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20 2007 10:56, Glauber de Oliveira Costa wrote:
>diff --git a/arch/x86_64/kernel/head64.c b/arch/x86_64/kernel/head64.c
>index 6c34bdd..dde41d7 100644
>--- a/arch/x86_64/kernel/head64.c
>+++ b/arch/x86_64/kernel/head64.c
>@@ -70,7 +70,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
> 
> 	for (i = 0; i < IDT_ENTRIES; i++)
> 		set_intr_gate(i, early_idt_handler);
>-	asm volatile("lidt %0" :: "m" (idt_descr));
>+	load_idt((const struct desc_ptr *)&idt_descr);

Cast is not required, &idt_descr is already 'struct desc_ptr *'. (Also
elsewhere)


	Jan
-- 
