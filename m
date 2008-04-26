Return-Path: <linux-kernel-owner+w=401wt.eu-S1765571AbYDZBNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765571AbYDZBNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 21:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYDZBNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 21:13:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYDZBNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 21:13:10 -0400
Date: Fri, 25 Apr 2008 18:12:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 PAT changes
In-Reply-To: <481271F4.7060401@zytor.com>
Message-ID: <alpine.LFD.1.10.0804251808590.2813@woody.linux-foundation.org>
References: <20080424225625.GB8717@elte.hu> <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org> <481271F4.7060401@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Apr 2008, H. Peter Anvin wrote:
> 
> The problem is that that can create cached/uncached aliases, which can cause
> some processors to lock up (especially AMD is known to have a lot of errata in
> this area.)

Umm.. I don't think you understand. Right now, NONPROMISC_DEVMEM doesn't 
just disable mmap() on /dev/mem, it disables totally regular reads and 
writes too. That seems pretty damn excessive.

If it was just mmap(), I don't think it would matter much. I don't think 
we traditionally even supported mmap() on real RAM (because the page 
counting would get confused), and that actually got supported only thanks 
to VM changes that made it possible.

But read/write has always been supported, and shouldn't cause any 
cached/uncached aliases!

		Linus
