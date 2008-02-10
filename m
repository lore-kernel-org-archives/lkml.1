Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYBJVLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYBJVLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYBJVLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:11:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:53207 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbYBJVLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BqLUAZKEZYGK4YM0SG8+a5bL4tLJNtfuDjTkU4uWiJQ6X99vfWJ3XRbmRZ44d4xcmbQx+xM/JlpRqH4k+HRg6Zh5juNq4gU3yvW7nglLe5faMcQPaUUa0T2UZkbEpO3npyk4pRa66v2p/CUpzqqutrQ7P5rx9IhVz2NJM5Tt8J4=
Message-ID: <57e2b00802101311g45c2469dy3a719ab27a9d5960@mail.gmail.com>
Date: Sun, 10 Feb 2008 21:11:13 +0000
From: "Byron Bradley" <byron.bbradley@gmail.com>
To: minyard@acm.org
Subject: Re: [PATCH] ARM: Ignore memory tags with invalid data
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, hvr@gnu.org,
       rmk@arm.linux.org.uk, nico@cam.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20080122040556.GA24515@minyard.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080122040556.GA24515@minyard.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008 4:05 AM, Corey Minyard <minyard@acm.org> wrote:
> From: Corey Minyard <minyard@acm.org>
>
> The DNS-323 system has several bogus memory entries in the tag table,
> and it caused the system to crash at startup.  Ignore tag entries that
> are obviously bogus.
>
> Signed-off-by: Corey Minyard <minyard@acm.org>
> ---
>  arch/arm/kernel/setup.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index bf56eb3..dfdb469 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -630,7 +630,12 @@ __tagtable(ATAG_CORE, parse_tag_core);
>
>  static int __init parse_tag_mem32(const struct tag *tag)
>  {
> -       if (meminfo.nr_banks >= NR_BANKS) {
> +       /*
> +        * Make sure that the memory size is non-zero, page aligned,
> +        * and that it doesn't overflow the meminfo table.
> +        */
> +       if (meminfo.nr_banks >= NR_BANKS || tag->u.mem.size & ~PAGE_MASK ||
> +           tag->u.mem.size == 0 || tag->u.mem.start & ~PAGE_MASK) {
>                 printk(KERN_WARNING
>                        "Ignoring memory bank 0x%08x size %dKB\n",
>                         tag->u.mem.start, tag->u.mem.size / 1024);
>

[Cc: linux-arm-kernel]

What's the status of this patch? It would be good to see it go in
because the problem it fixes can be seen on a large number of NAS
devices.

Cheers,

-- 
Byron Bradley
