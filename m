Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbYHSSdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbYHSSdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYHSSda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:33:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38823 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYHSSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:33:29 -0400
Date: Tue, 19 Aug 2008 14:33:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: update recordmount.pl arch changes
In-Reply-To: <20080815154234.GE27955@elte.hu>
Message-ID: <alpine.DEB.1.10.0808191430010.28232@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808151136310.2188@gandalf.stny.rr.com> <20080815154234.GE27955@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 15 Aug 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > I'm trying to keep all the arch changes in recordmcount.pl in one 
> > place. I moved your code into that area, by adding the flags to the 
> > commands that were passed in.
> > 
> > Does this change still work for you when compiling i386 on a x86_64 
> > box?
> 
> actually, i thought of this as a quick hack to let -tip testing 
> continue. Dont we have all the proper information available in kbuild 
> and should just pass that to scripts/recordmcount.pl when called - like 
> we pass in things like OBJDUMP which might have cross-build overrides, 
> etc.

Ingo,

Could you use my updated patch. I know it is still just a work around, but 
your update broke my build.  I use distcc which passes in "distcc" as gcc. 
My distcc is self built and is not the same as the distribution gcc.

Ie, you have:

if ($arch eq "x86_64") {
  $ld = "ld -m elf_x86_64";
  $objdump = "objdump -M x86-64";
  $objcopy = "objcopy -O elf64-x86-64";
  $cc = "gcc -m64";
}

Where the $cc = "gcc" is not compatible on my system. I end up with a bad 
build that causes ftrace to fail on bootup.


-- Steve

