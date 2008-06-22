Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYFVTis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYFVTis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbYFVTik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:38:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:42313 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbYFVTij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RUwM0lwwxl3sLKuhJB1hLiK/37R2WqgbOwRS4RtFU1fZE3UdovwIYuITJ7IE4fsOUy
         e/Q8AxkCP0Kk3tg6CsZEEIIezxAvFEXMYSXvj28v+btpKbWUkgSkz2nkG5io5ia135lq
         DlZNYauSpr7k7Uvh070+yt0tWwqle5cLWdHmw=
Message-ID: <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
Date: Sun, 22 Jun 2008 12:38:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal in some kernel info printks
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 7:22 AM, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
> Page frame numbers (the portion of physical addresses above the low
> order page offsets) are displayed in several kernel debug and info
> prints in decimal, not hex.  Decimal addresse are unreadable.  Use hex.
>
> Signed-off-by: Paul Jackson <pj@sgi.com>
>
> ---
>  arch/x86/kernel/e820.c |    2 +-
>  arch/x86/mm/init_64.c  |    2 +-
>  mm/page_alloc.c        |    6 +++---
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> --- linux-next.orig/arch/x86/kernel/e820.c      2008-06-22 06:36:07.203937695 -0700
> +++ linux-next/arch/x86/kernel/e820.c   2008-06-22 06:36:16.792519156 -0700
> @@ -922,7 +922,7 @@ unsigned long __init e820_end_of_ram(voi
>        if (last_pfn > end_user_pfn)
>                last_pfn = end_user_pfn;
>
> -       printk(KERN_INFO "last_pfn = %lu max_arch_pfn = %lu\n",
> +       printk(KERN_INFO "last_pfn = 0x%lx max_arch_pfn = 0x%lx\n",

we should remove 0x,
and hex print out all the way...regarding mem pfn and memory address,
memory size etc. except XXXMB. XXXKB...

YH
