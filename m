Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZABCHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZABCHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 21:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbZABCHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 21:07:41 -0500
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:12471 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbZABCHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 21:07:40 -0500
Date: Fri, 2 Jan 2009 03:07:38 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tom Spink <tspink@gmail.com>
cc: Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org
Subject: Re: compile time warnings
In-Reply-To: <7b9198260901011735k42e9298tb1c5dc0e15285eb1@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0901020301230.11772@swampdragon.chaosbits.net>
References: <495d3100@wupperonline.de>  <alpine.LNX.2.00.0901012312450.11772@swampdragon.chaosbits.net> <7b9198260901011735k42e9298tb1c5dc0e15285eb1@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jan 2009, Tom Spink wrote:

> 2009/1/1 Jesper Juhl <jj@chaosbits.net>:
> > On Thu, 1 Jan 2009, Ingo Brueckl wrote:
> [snip]
> 
> Hi,
> 
> > pgd_base is very much used...
> 
> It's probably something to do with:
> 
> # define permanent_kmaps_init(pgd_base)         do { } while (0)
> 
> Which is within the #else part of #if CONFIG_HIGHMEM.  So, if
> CONFIG_HIGHMEM is not set, permanent_kmaps_init gets wiped out, and
> therefore that warning will be issued.
> 
> Perhaps changing that to an empty inline would remove the warning?
> 
Yeah, I noticed that as well after sending the mail.
Another way to silence the warning (which I think is nicer) would be 
something like this;


Silence 'unused variable' warning in arch/x86/mm/init_32.c::pagetable_init

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 8655b5b..0affa8e 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -511,9 +511,7 @@ static void __init early_ioremap_page_table_range_init(pgd_t *pgd_base)
 
 static void __init pagetable_init(void)
 {
-	pgd_t *pgd_base = swapper_pg_dir;
-
-	permanent_kmaps_init(pgd_base);
+	permanent_kmaps_init((pgd_t *)swapper_pg_dir);
 }
 
 #ifdef CONFIG_ACPI_SLEEP
 

-- 
Jesper Juhl <jj@chaosbits.net>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

