Return-Path: <linux-kernel-owner+w=401wt.eu-S1763669AbYJJUjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763669AbYJJUjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759200AbYJJUjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:39:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:39813 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYJJUjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cj7okaCPYXBHm1+73wMtCWYFlc36C7RDhSE18a/i+4sVrjzrbpWh8bNGZJiHnhMhqN
         EEsviiMhlUKfjrvi9kSF7RZQaaqfi5uHHwcfNwPyS1EJdoza/tQkBToGEG5VEhzkOSWb
         X06eohTB02XKv5hasQ0Cr3iWYFQ8DZTTlQOFU=
Message-ID: <19f34abd0810101339x66afc6d3mb6efa1a52e186816@mail.gmail.com>
Date: Fri, 10 Oct 2008 22:39:23 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #1
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081010155830.GA4767@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20081009234705.GA20540@elte.hu>
	 <alpine.LFD.2.00.0810100808540.3524@nehalem.linux-foundation.org>
	 <20081010152631.GB26231@elte.hu> <20081010155830.GA4767@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9AKdcdq003668

On Fri, Oct 10, 2008 at 5:58 PM, Ingo Molnar <mingo@elte.hu> wrote:>> * Ingo Molnar <mingo@elte.hu> wrote:>>> > Ok, so I pulled phase 1, but quite frankly, I think this was utter>> > crap. Why the hell did this go in?>>>> we'll fix that up. We'll move all header files to>> arch/x86/include/asm/ anyway later in the merge window, once the dust>> settles, and can do a separate commit for this as well.>> we'll do the commit below once we've moved the header files to> arch/x86/include/asm/. (doing it right now would conflict with various> existing branches so it would be nice to wait with this.)>>        Ingo>> ---------------->> From 5f3a8db0d4b091521541153580454099618fec2c Mon Sep 17 00:00:00 2001> From: Ingo Molnar <mingo@elte.hu>> Date: Fri, 10 Oct 2008 17:51:28 +0200> Subject: [PATCH] x86: fix header guard naming ugliness>> as Linus has noticed, the underscore aspect of these changes in> 77ef50a ("x86: consolidate header guards") are bogus:>> -#ifndef _ASM_BOOT_H> -#define _ASM_BOOT_H> +#ifndef ASM_X86__BOOT_H> +#define ASM_X86__BOOT_H>> as Linus pointed out:>> 1) header guard symbols are internal symbols in a reserved namespace,>   so a leading underscore is perfectly justified>> 2) user-space might accidentally stumble into the new symbols:>>        #include <sys/types.h>>>        int ASM_X86__TYPES_H = 1;>> plus this deviates from all the standard header guard naming we> use elsewhere in the kernel.
Note: If you don't want the double underscores anywhere, this patch isnot enough.
For example:
> -#endif /* ASM_X86__MACH_DEFAULT__MACH_TIMER_H */> +#endif /* _ASM_X86_MACH_DEFAULT__MACH_TIMER_H */
There are also a few non-trivial changes, which could break with anaÃ¯ve sed script. So I suggest to simply revert it, it's a lot saferthan trying to patch it up in the last minute.
I'm obviously also sorry for causing this problem in the first place... *blush*

Vegard
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
