Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYFYP4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYFYP4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbYFYP4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:56:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:20100 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYFYP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:56:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Zexz42cRMv29xiZE2PeKS5MBNuWmOnBzn/u1rr1ZT4xjp6QbZv/nybM4rmaaAGT0xr
         54Q4amnuUmX6N3T0IHY5VXcXmORHTbViGFRoBnyH3gGwaSL2Y3Hbq3kJ5xBGXsPzTzHW
         Hlk0pk70LXqOrorp6V4D4Jb2jyUSJdFjGapvQ=
Message-ID: <86802c440806250856i5b6c608ag848ad78d83b2337c@mail.gmail.com>
Date: Wed, 25 Jun 2008 08:56:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH 1/3] e820_update_range(): Strip size of original region
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       kexec@lists.infradead.org
In-Reply-To: <1214395342-20375-2-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214395342-20375-1-git-send-email-bwalle@suse.de>
	 <1214395342-20375-2-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 5:02 AM, Bernhard Walle <bwalle@suse.de> wrote:
> This patch fixes a bug in e820_update_range(): Previously, if a region was
> partially covered, then e820_update_range() only added a new E820 range but
> didn't update the end/size of the previous range. That lead to duplicate
> covering of a region.
>
> Patch tested on i386 and x86-64 with patch that uses e820_update_range()
> to limit the E820 map when "mem" parameter is specified on the command line.
>
>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  arch/x86/kernel/e820.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index e285ea3..e466073 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -422,6 +422,7 @@ u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
>                final_end = min(start + size, ei->addr + ei->size);
>                if (final_start >= final_end)
>                        continue;
> +               ei->size -= final_end - final_start;
>                e820_add_region(final_start, final_end - final_start,
>                                         new_type);
>                real_updated_size += final_end - final_start;
> --

this one is not needed, I sent one updated to Ingo, and it is in
tip/setup-memory
[PATCH] x86: change size if e820_update/remove_range

YH
