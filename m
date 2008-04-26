Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbYDZRQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbYDZRQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbYDZRQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:16:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758383AbYDZRQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:16:04 -0400
Date: Sat, 26 Apr 2008 10:15:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [git pull] x86 PAT changes
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEF313A6@orsmsx423.amr.corp.intel.com>
Message-ID: <alpine.LFD.1.10.0804261011030.2813@woody.linux-foundation.org>
References: <20080424225625.GB8717@elte.hu> <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org> <481271F4.7060401@zytor.com> <alpine.LFD.1.10.0804251808590.2813@woody.linux-foundation.org> <20080426085600.GA5891@elte.hu>
 <924EFEDD5F540B4284297C4DC59F3DEEF313A6@orsmsx423.amr.corp.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Pallipadi, Venkatesh wrote:
> 
> Agreed that NONPROMISC_DEVMEM is not really needed for read/write. But,
> we will still need it for /dev/mem.

If so, just disable it unconditionally for mmap.

As mentioned, that's really just a return to original Linux /dev/mmap 
semantics: long ago (well, not _that_ long ago) we never used to be able 
to mmap() normal kernel memory, because the page counts would get screwed 
up on pages that weren't marked PG_Reserved.

So the traditional Linux behavior for mmap() on /dev/mem was always to 
only allow it on memory that either had no "struct page *" backing at all, 
or that was marked PG_Reserved (ie the ISA hole ay 640k-1M and things like 
the BIOS tables etc).

Going back to that doesn't sound horrible.

		Linus
