Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZHDDOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZHDDOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 23:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZHDDOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 23:14:03 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:56919 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbZHDDOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 23:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kiy6I+u0eefyakzEwytEmQh7SM+t4mHwjDL7PyMjMmHGJEbO+b66+nBsz6FJT3ZBvz
         l5H5kvU6APaRxUIkw+B7Arjq30p3RTXWnNI7U6TbwX0R3A7jvY3aLTdRW3CYQryn6nJE
         IOOwvbQHEVqZfu0F+4G7hfA1mg0g6/Ai9xAHI=
Date: Tue, 4 Aug 2009 11:16:15 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drop superfluous casts in nr_free_pages() callers
Message-ID: <20090804031615.GB5050@cr0.nay.redhat.com>
References: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 06:11:42PM +0200, Geert Uytterhoeven wrote:
>Commit 96177299416dbccb73b54e6b344260154a445375 ("Drop free_pages()")
>modified nr_free_pages() to return 'unsigned long' instead of 'unsigned int'.
>This made the casts to 'unsigned long' in most callers superfluous, hence
>remove them.
>
>Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>---

>diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
>index 61d7e61..a5d5e70 100644
>--- a/arch/um/kernel/mem.c
>+++ b/arch/um/kernel/mem.c
>@@ -77,7 +77,7 @@ void __init mem_init(void)
> 	num_physpages = totalram_pages;
> 	max_pfn = totalram_pages;
> 	printk(KERN_INFO "Memory: %luk available\n",
>-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10));
>+	       nr_free_pages() << (PAGE_SHIFT-10));
> 	kmalloc_ok = 1;
> 
> #ifdef CONFIG_HIGHMEM

Since it is fine for other arch, um too.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
