Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbYD2PvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbYD2PvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbYD2Puj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:50:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594AbYD2Pui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:50:38 -0400
Message-ID: <481742C1.5040709@zytor.com>
Date: Tue, 29 Apr 2008 08:46:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs v2
References: <20080424144120.GA7717@cvg> <4810CC2F.3010600@zytor.com> <20080428182323.GD1685@elte.hu> <20080428192039.GA10267@elte.hu> <20080429152947.GB6837@cvg> <20080429154330.GC6837@cvg>
In-Reply-To: <20080429154330.GC6837@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> | 
> | with this patch we have <asm/vm86.h> included only
> | if __i386__ defined *BUT* X86_VM_MASK is tried to be
> | used *without* __386__ being checked (as example - ptrace.h:user_mode_vm).
> | I'm not sure how to properly hanle this situation. But will take a look.
> | 
> | So I suggest you drop my last patch (which moves X86_VM_MASK
> | into __KERNEL__ section) for a while. I'll recheck all
> | this stuff later (too busy now).
> | 
> | 		- Cyrill -
> 
> Thomas, could you take a look please - is my suspicious wrong?
> 
> 		- Cyrill -

X86_VM_MASK should be defined to zero on x86-64.  Part of the reason for 
this symbol is so we don't have to put #ifdef around its uses.

	-hpa
