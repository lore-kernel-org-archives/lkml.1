Return-Path: <linux-kernel-owner+w=401wt.eu-S1764372AbXJTP5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764372AbXJTP5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 11:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbXJTP5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 11:57:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54394 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764AbXJTP5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:57:32 -0400
Date: Sat, 20 Oct 2007 08:56:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git/cscope with x86 merge
In-Reply-To: <86802c440710200240o7aae2760o5fa9c70e3b327097@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0710200854550.3794@woody.linux-foundation.org>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com> 
 <alpine.LFD.0.999.0710151256260.6887@woody.linux-foundation.org>
 <86802c440710200240o7aae2760o5fa9c70e3b327097@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Oct 2007, Yinghai Lu wrote:
> 
> git log -p --follow arch/x86/kernel/vmlinux_64.lds.S
> 
> can not trace to arch/x86_64/kernel/vmlinux.lds.S

Hmm. I get:

	[torvalds@woody linux]$ git log --stat --follow arch/x86/kernel/vmlinux_64.lds.S
	commit 250c22777fe1ccd7ac588579a6c16db4c0161cc5
	Author: Thomas Gleixner <tglx@linutronix.de>
	Date:   Thu Oct 11 11:17:24 2007 +0200
	
	    x86_64: move kernel
	
	    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
	    Signed-off-by: Ingo Molnar <mingo@elte.hu>
	
	 arch/{x86_64 => x86}/kernel/vmlinux_64.lds.S |    0
	 1 files changed, 0 insertions(+), 0 deletions(-)
	
	commit 13a9cd42466e12113859c4d7b41561e8bbcaf09d
	Author: Thomas Gleixner <tglx@linutronix.de>
	Date:   Thu Oct 11 11:14:21 2007 +0200
	
	    x86_64: prepare shared kernel/vmlinux.lds.S
	
	    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
	    Signed-off-by: Ingo Molnar <mingo@elte.hu>
	
	 arch/x86_64/kernel/vmlinux_64.lds.S |  235 +++++++++++++++++++++++++++++++++++
	 1 files changed, 235 insertions(+), 0 deletions(-)


so it definitely works for me.

But it might be the same old rename limit issue. Try doing

	git config --global diff.renamelimit 0

first,

		Linus
