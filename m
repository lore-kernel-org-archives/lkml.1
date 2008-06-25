Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYFYQBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYFYQBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYFYQBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:01:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:22659 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYFYQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C8RdG4OJhYA3/JDWs9AKJpTaeyHC101f+4BNqdfc+B8kSKEYLcAkzUHcfAkCeX2Vuv
         0cok7tDvuG1LdXqiXr9KsQXzxfuiooLOz00WMRVGNrV5D8YA2caUzqOIO98GPi0Py6Ee
         jYCX3gttnqMMr7Hd2NlkWABvuBlKC05U6XpKQ=
Message-ID: <86802c440806250901n68278ab1ma1add38c165122af@mail.gmail.com>
Date: Wed, 25 Jun 2008 09:01:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH 3/3] Limit E820 map when a user-defined memory map is specified
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       kexec@lists.infradead.org
In-Reply-To: <1214395342-20375-4-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214395342-20375-1-git-send-email-bwalle@suse.de>
	 <1214395342-20375-4-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 5:02 AM, Bernhard Walle <bwalle@suse.de> wrote:
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
> +
>        return 0;
>  }
>  early_param("mem", parse_memopt);
> @@ -1023,6 +1025,7 @@ static int __init parse_memmap_opt(char *p)
>                e820_add_region(start_at, mem_size, E820_RESERVED);
>        } else {
>                end_user_pfn = (mem_size >> PAGE_SHIFT);
> +               e820_update_range(mem_size, ULLONG_MAX, E820_RAM, E820_RESERVED);
>        }
>        return *p == '\0' ? 0 : -EINVAL;
>  }
> --

only this one is needed now. but please change ULLONG_MAX to
ULLONG_MAX - mem_size

YH
