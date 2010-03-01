Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab0CAQdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:33:05 -0500
Received: from www.tglx.de ([62.245.132.106]:43171 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0CAQdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:33:02 -0500
Date: Mon, 1 Mar 2010 17:31:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Xiaotian Feng <xtfeng@gmail.com>, Sachin Sant <sachinp@in.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: 2.6.33-git6 boot failure[x86_64] (WARN: at
 arch/x86/mm/ioremap.c:111)
In-Reply-To: <20100301135551.GA9998@localhost>
Message-ID: <alpine.LFD.2.00.1003011728450.4245@localhost.localdomain>
References: <4B8B43E9.1010506@in.ibm.com> <7b6bb4a51002282218u22c8f4c4wb2a345fcb7a82257@mail.gmail.com> <4B8B7AC7.1070201@in.ibm.com> <7b6bb4a51003010038l49c90414lff1ecaa37c96ad61@mail.gmail.com> <alpine.LFD.2.00.1003011058470.4245@localhost.localdomain>
 <20100301135551.GA9998@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010, Wu Fengguang wrote:
 Ah walk_system_ram_range() is actually doing almost the same alignment
> check as the removed x86 page_is_ram(), except that it calls func()
> with len=0.  This happens when page_is_ram(cffa3000) is called.
> 
> walk_system_ram_range():
>     pfn = (unsigned long)(res.start >> PAGE_SHIFT);
>     len = (unsigned long)((res.end + 1 - res.start) >> PAGE_SHIFT);
>     ret = (*func)(pfn, len, arg);
> 
> The following patch should fix the problem.

Right, that should fix it. Though I wonder whether we should warn
prominently about non page aligned e820 mapping entries.

Thanks,

	tglx
