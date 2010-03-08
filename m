Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0CHN3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:29:21 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:33419 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab0CHN3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:29:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ibzm0GSk1wEh/Kyd/ZNJ9JK6ckYhbz0cHtGDHCnWzqnXiw4IFbOOyhQuPZspeBC/mZ
         9Yk3D9nNQfCxp4s+JSvV616j+MBMLbmlT+nXnao+0k8iWtzA2EeKXGOunI9s0qN6HOYn
         21dBYmkMxFBwXi8ibJ8NNVwqz/YnEIWke2JQM=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain>
References: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain>
Date: Mon, 8 Mar 2010 15:29:16 +0200
X-Google-Sender-Auth: b53069534c428bc1
Message-ID: <84144f021003080529w1b20c08dmf6871bd46381bc71@mail.gmail.com>
Subject: Re: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 11:21 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> __zone_pcp_update() iterates over NR_CPUS instead of limiting the
> access to the possible cpus. This might result in access to
> uninitialized areas as the per cpu allocator only populates the per
> cpu memory for possible cpus.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Looks OK to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -3224,7 +3224,7 @@ static int __zone_pcp_update(void *data)
>        int cpu;
>        unsigned long batch = zone_batchsize(zone), flags;
>
> -       for (cpu = 0; cpu < NR_CPUS; cpu++) {
> +       for_each_possible_cpu(cpu) {
>                struct per_cpu_pageset *pset;
>                struct per_cpu_pages *pcp;
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
