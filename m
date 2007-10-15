Return-Path: <linux-kernel-owner+w=401wt.eu-S933983AbXJOUCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbXJOUCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933095AbXJOUCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:02:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765796AbXJOUC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:02:29 -0400
Date: Mon, 15 Oct 2007 13:00:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git/cscope with x86 merge
In-Reply-To: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0710151256260.6887@woody.linux-foundation.org>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Oct 2007, Yinghai Lu wrote:
>
> after the merge:
> 1. git
> git log -p arch/x86/kernel/io_apic_64.c
> only can show the log from the merge..., and can not get log before
> merge for x86_64/kernel/io_apic.c
> Any git update for that?

Use

	git log -p --follow arch/x86/kernel/io_apic_64.c

where the "--follow" tells git to follow renames.

And, of course, "git blame -C" will follow renames and copying of code 
across file boundaries too.

NOTE! In both cases you may actually have to tell git to not limit its 
rename detection when it sees lots of files. You can do that 
once-and-for-all with

	git config --global diff.renamelimit 0

which should take care of it (although it seems that due to unlucky 
timing, the current stable git release does not honor the renamelimit for 
merging, so if you actually need to have git merge data across a rename, 
you should use the current "master" branch of git. Junio is sadly away 
for two weeks right now)

> 2. cscope

No idea on cscope..

		Linus
