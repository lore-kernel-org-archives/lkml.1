Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYFYT7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYFYT7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYFYT7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:59:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:43051 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYFYT7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Czc8HgJ8fYCedNCNHgNJl53XPNo40o85jWAzVSf5y9b36p4qqxBd6xZdQqbgv4F34p
         xQ0SepsZMaxbYDi4C9VYo9ly1nozshnkEt7zuWAOe4YzzJAIeEuTdQXPUdDq4P7TzDh2
         5jHF9uwNqIoJYRQzxZf9CKkEcfPvxzgyewQJw=
Message-ID: <86802c440806251259o6b1b1038v9f645992415f0372@mail.gmail.com>
Date: Wed, 25 Jun 2008 12:59:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH] x86: Limit E820 map when a user-defined memory map is specified
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       vgoyal@redhat.com
In-Reply-To: <1214422756-10923-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214422756-10923-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 12:39 PM, Bernhard Walle <bwalle@suse.de> wrote:
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

Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>

> ---
>  arch/x86/kernel/e820.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index a1b0548..3771386 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -988,6 +988,9 @@ static int __init parse_memopt(char *p)
>
>        mem_size = memparse(p, &p);
>        end_user_pfn = mem_size>>PAGE_SHIFT;
> +       e820_update_range(mem_size, ULLONG_MAX - mem_size,
> +               E820_RAM, E820_RESERVED);
> +
>        return 0;
>  }
>  early_param("mem", parse_memopt);
> @@ -1032,6 +1035,8 @@ static int __init parse_memmap_opt(char *p)
>                e820_add_region(start_at, mem_size, E820_RESERVED);
>        } else {
>                end_user_pfn = (mem_size >> PAGE_SHIFT);
> +               e820_update_range(mem_size, ULLONG_MAX - mem_size,
> +                       E820_RAM, E820_RESERVED);
>        }
>        return *p == '\0' ? 0 : -EINVAL;
>  }
> --
