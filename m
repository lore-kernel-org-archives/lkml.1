Return-Path: <linux-kernel-owner+w=401wt.eu-S933424AbYDYXon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424AbYDYXon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbYDYXoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:44:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933045AbYDYXoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:44:24 -0400
Date: Fri, 25 Apr 2008 16:43:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 PAT changes
In-Reply-To: <20080424225625.GB8717@elte.hu>
Message-ID: <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org>
References: <20080424225625.GB8717@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Apr 2008, Ingo Molnar wrote:
> Linus, please pull the x86-pat git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-pat.git for-linus
> 
> this adds the second (and final) phase of the x86 PAT changes. Due to 
> generic impact (the drivers/char/mem.c and include/asm-generic/iomap.h 
> changes) this is offered as a separate tree.

So why is PAT dependent on NONPROMISC_DEVMEM here?

It seems pointless and wrong. Somebody might want to have both the full 
/dev/mem and PAT.

Also, it causes this message for me on one of my machines:

	EXT3-fs: mounted filesystem with ordered data mode.
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0400000
	mtrr: no more MTRRs available
	Overlap at 0xd0000000-0xe0000000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0380000
	EXT3 FS on dm-0, internal journal
	...
	eth0: no IPv6 routers present
	Overlap at 0xd0000000-0xe0000000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0380000
	Overlap at 0xd0000000-0xe0000000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0380000
	Overlap at 0xd0000000-0xe0000000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0380000
	Overlap at 0xd0000000-0xe0000000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0380000
	Overlap at 0xd0000000-0xe0000000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0380000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xd0000000-0xd0020000
	mtrr: no more MTRRs available
	Overlap at 0xd0000000-0xe0000000
	Overlap at 0xe0300000-0xe0400000
	Overlap at 0xe0300000-0xe0380000

which is a bit annoying. Forgotten debug printk, perhaps?

			Linus
