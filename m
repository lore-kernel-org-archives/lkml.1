Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYFXUDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYFXUDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 16:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYFXUDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 16:03:34 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:53235 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYFXUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 16:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=em1YsUqtoy1xZuBDXjmYX3b3oHs6cE/oAbARjzqlvPjVobD+dGTxgx/++L1cQJYnqS
         Mq7CJqCyzwok9w1W0SPeM7bJ/N2rO0pqlf9TFiMrGKppkPLHX0ExmFNNrWE60DnrR7nU
         6efTjTB4+QQcDtsU23+DlbtGKIuHe1jTnAm8Y=
Message-ID: <86802c440806241303p26b2242k43fea42f106125fa@mail.gmail.com>
Date: Tue, 24 Jun 2008 13:03:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] Limit E820 map when a user-defined memory map is specified
Cc: x86@kernel.org, vgoyal@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1214318125-32619-4-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214318125-32619-1-git-send-email-bwalle@suse.de>
	 <1214318125-32619-4-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 7:35 AM, Bernhard Walle <bwalle@suse.de> wrote:
> This patch brings back limiting of the E820 map when a user-defined
> E820 map is specified. While the behaviour of i386 (32 bit) was to limit
> the E820 map (and /proc/iomem), the behaviour of x86-64 (64 bit) was not to
> limit.
>
> That patch limits the E820 map again for both x86 architectures.
>
> Code was tested for compilation and booting on a 32 bit and 64 bit system.
>
>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  arch/x86/kernel/e820.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 7d1109b..19b7f05 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -979,6 +979,8 @@ static int __init parse_memopt(char *p)
>
>        mem_size = memparse(p, &p);
>        end_user_pfn = mem_size>>PAGE_SHIFT;
> +       e820_update_range(mem_size, ULLONG_MAX, E820_RAM, E820_RESERVED);
==>
+       e820_update_range(mem_size, ULLONG_MAX - mem_size, E820_RAM,
E820_RESERVED);
> +
>        return 0;
>  }
>  early_param("mem", parse_memopt);
> @@ -1023,6 +1025,7 @@ static int __init parse_memmap_opt(char *p)
>                e820_add_region(start_at, mem_size, E820_RESERVED);
>        } else {
>                end_user_pfn = (mem_size >> PAGE_SHIFT);
> +               e820_update_range(mem_size, ULLONG_MAX, E820_RAM, E820_RESERVED);
==>
+       e820_update_range(mem_size, ULLONG_MAX - mem_size, E820_RAM,
E820_RESERVED);

YH
