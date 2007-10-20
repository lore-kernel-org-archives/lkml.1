Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbXJTSUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbXJTSUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbXJTSUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:20:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757071AbXJTSUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:20:35 -0400
Date: Sat, 20 Oct 2007 11:19:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git/cscope with x86 merge
In-Reply-To: <20071020164752.GB6855@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.999.0710201058300.3794@woody.linux-foundation.org>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com>
 <alpine.LFD.0.999.0710151256260.6887@woody.linux-foundation.org>
 <86802c440710200240o7aae2760o5fa9c70e3b327097@mail.gmail.com>
 <alpine.LFD.0.999.0710200854550.3794@woody.linux-foundation.org>
 <20071020164752.GB6855@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Oct 2007, Sam Ravnborg wrote:
> 
> But you do not see the rename arch/x86_64/kernel/{vmlinux.lds.S => vmlinux.lds.S}

Umm. What you are describing isn't a rename - that's the same name. Do you 
perhaps mean vmlinux.lds.S => vmlinux_64.lds.S ?

And yes, it doesn't show that as a rename, because of the fact that the

	arch/x86_64/kernel/vmlinux.lds.S

file actually *remained*, so it wasn't really a rename. It just got almost 
all of its data changed.

So there was never really a rename: there was a "copy" and a "rewrite". 
And "git --follow" doesn't follow copies.

However, "git blame" does do so. So if you do

	git blame -C arch/x86/kernel/vmlinux_64.lds.S

(where that -C tells it to follow data across file copies), it will 
actually show the history down, line for line!

But when you try to follow the history of the whole *file*, git sees that 
the filename still existed of the source, so it won't consider that a 
candidate for renames!

I could perhaps look at making "git log --follow" also break up files that 
got totally rewritten (git already has a notion of "-B" to do that), but 
no, we don't do it right now. (But one of the advantages of the git model 
is that none of this is hardcoded in the repository data itself, so we can 
improve the rename following and it will automatically work with any repo, 
even one created with older git versions)

		Linus
