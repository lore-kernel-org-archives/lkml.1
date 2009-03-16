Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbZCPSVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbZCPSVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZCPSVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:21:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:4363 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbZCPSVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H1OcdZ9j0ZolWULVWyGzuUl0BdEwP9crZ7Bd4HMu9q5EHQBlj6Oz8OoxJYsAgvkuiF
         27aeetoy+bUs+OsN3uA+L3kDc8exM4Sn39tVa1cYvDtO84Yvp422OpjnkobiPw8zP6G0
         H7qow6+Oea8uMIQRS8335V3HmJfb3StRj22kM=
MIME-Version: 1.0
In-Reply-To: <49BE58BA.1000907@pardus.org.tr>
References: <49BE58BA.1000907@pardus.org.tr>
Date: Mon, 16 Mar 2009 11:21:09 -0700
X-Google-Sender-Auth: 96d3ff9f46915f56
Message-ID: <86802c440903161121s3ba18abaiaa3ccf6847e0eafe@mail.gmail.com>
Subject: Re: [BUG 2.6.29_rc8] BIOS Bug: CPU MTRRs don't cover all of memory, 
	losing 0MB of RAM.
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-9?Q?Ozan_=C7a=F0layan?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 6:48 AM, Ozan Çaðlayan <ozan@pardus.org.tr> wrote:
> Hi,
>
> Just compiled and tried to boot it on an HP ProLiant DL580 G5. Here's the
> interesting part:
>
> ..
> -- last_pfn = 0x82ffff max_arch_pfn = 0x1000000
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 0MB of RAM.
> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1655 mtrr_trim_uncached_memory+0x2a9/0x2cd()
> Hardware name: ProLiant DL580 G5
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.29_rc8-115 #1
> Call Trace:
>  [<c013134d>] warn_slowpath+0x71/0xa8
>  [<c039971c>] ? _spin_unlock_irqrestore+0x19/0x1f
>  [<c039971c>] ? _spin_unlock_irqrestore+0x19/0x1f
>  [<c01319c4>] ? release_console_sem+0x185/0x1b2
>  [<c0131e49>] ? vprintk+0x280/0x2a5
>  [<c03973da>] ? printk+0xf/0x15
>  [<c053423f>] mtrr_trim_uncached_memory+0x2a9/0x2cd
>  [<c052f4bd>] setup_arch+0x439/0x99e
>  [<c01319c4>] ? release_console_sem+0x185/0x1b2
>  [<c0131e49>] ? vprintk+0x280/0x2a5
>  [<c0531b37>] ? __reserve_early+0xe4/0xf8
>  [<c03973da>] ? printk+0xf/0x15
>  [<c052b5b6>] start_kernel+0x7b/0x345
>  [<c052b085>] __init_begin+0x85/0x8d
> ---[ end trace 4eaa2a86a8e2da22 ]---
> update e820 for mtrr
> ..
>
> This is a quite generic x86 desktop kernel with only the
> following differences for the server:
>
> CONFIG_X86_GENERICARCH=y
> CONFIG_X86_BIGSMP=y
> CONFIG_MCORE2=y
> CONFIG_HIGHMEM64G=y
> # CONFIG_X86_GENERIC is not set
>
> I didn't want to add full dmesg and config for not flooding the e-mail but
> if you need them or other output/information, i can send them.
>

can you check tip/master?

http://people.redhat.com/mingo/tip.git/readme.txt

and post boot log.

YH
