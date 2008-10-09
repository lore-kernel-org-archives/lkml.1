Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbYJIGEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbYJIGEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYJIGEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:04:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:63679 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYJIGEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=K4gCbNQRL9pk55Ox6Olld/R9VzHVH2S1pZ2Ehwr6zU1V2G9ws9WgENZQGxC+dkdDsq
         qDO58JsG7lkq+ddoWIzeRhaWL74xSxADRIbATMG6joqoqGmKmLVGQGWyio4dN5O66LQL
         b3AUJM1wRz/q4zDm0Nx6G7SIIL1H3cxD1qtq8=
Message-ID: <86802c440810082304j3274555etb7eca011f7459253@mail.gmail.com>
Date: Wed, 8 Oct 2008 23:04:33 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: [patch]x86: arch_add_memory round up address
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@redhat.com>
In-Reply-To: <1223530290.30941.9.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223530290.30941.9.camel@sli10-desk.sh.intel.com>
X-Google-Sender-Auth: 4749bee1be93ab50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2008 at 10:31 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> Round up address to a page, otherwise the last page isn't mapped.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  arch/x86/mm/init_64.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: linux/arch/x86/mm/init_64.c
> ===================================================================
> --- linux.orig/arch/x86/mm/init_64.c    2008-10-09 11:42:33.000000000 +0800
> +++ linux/arch/x86/mm/init_64.c 2008-10-09 11:43:22.000000000 +0800
> @@ -721,7 +721,8 @@ int arch_add_memory(int nid, u64 start,
>        unsigned long nr_pages = size >> PAGE_SHIFT;
>        int ret;
>
> -       last_mapped_pfn = init_memory_mapping(start, start + size-1);
> +       last_mapped_pfn = init_memory_mapping(start,
> +               round_up(start + size-1, PAGE_SIZE));
>        if (last_mapped_pfn > max_pfn_mapped)
>                max_pfn_mapped = last_mapped_pfn;

should use

last_mapped_pfn = init_memory_mapping(start, start + size);

YH
