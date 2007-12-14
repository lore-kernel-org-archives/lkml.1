Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbXLNIbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbXLNIbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbXLNIa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:30:56 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:29374
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756376AbXLNIaz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:30:55 -0500
Message-Id: <47624D81.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 14 Dec 2007 08:31:45 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Glauber de Oliveira Costa" <glommer@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86: clean up asm-x86/page*.h
References: <47623AD6.6090403@goop.org>
In-Reply-To: <47623AD6.6090403@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>--- a/arch/x86/mm/fault_64.c
>+++ b/arch/x86/mm/fault_64.c
>@@ -158,22 +158,22 @@ void dump_pagetable(unsigned long addres
> 	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK); 
> 	pgd += pgd_index(address);
> 	if (bad_address(pgd)) goto bad;
>-	printk("PGD %lx ", pgd_val(*pgd));
>+	printk("PGD %lx ", (unsigned long)pgd_val(*pgd));

Casts like this here and elsewhere look rather odd (in fact I think using
casts should really be limited to places where you either can't do it
differently or the code would become badly readable or much uglier
without them). I would therefore favor simply using the right formatting
specifier here.

Jan

