Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYKAKRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYKAKRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 06:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYKAKQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 06:16:58 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:35896 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYKAKQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 06:16:57 -0400
Date: Sat, 1 Nov 2008 11:16:52 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
In-Reply-To: <20081031095544.GI30317@elte.hu>
Message-ID: <Pine.LNX.4.64.0811011116010.7456@anakin>
References: <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
 <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
 <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin>
 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
 <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com>
 <20081023163433.GA3160@x200.localdomain> <20081030214910.GA14679@x200.localdomain>
 <Pine.LNX.4.64.0810310949190.22521@anakin> <20081031095544.GI30317@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Ingo Molnar wrote:
> * Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Fri, 31 Oct 2008, Alexey Dobriyan wrote:
> > > On Thu, Oct 23, 2008 at 08:34:33PM +0400, Alexey Dobriyan wrote:
> > > > On Thu, Oct 23, 2008 at 07:27:48PM +0200, Frederic Weisbecker wrote:
> > > > > When tracing is enabled, some arch have included <linux/irqflags.h>
> > > > > on their <asm/system.h> but others like alpha or m68k don't.
> > > > > 
> > > > > Build error on alpha:
> > > > > 
> > > > > kernel/trace/trace.c: In function 'tracing_generic_entry_update':
> > > > > kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
> > > 
> > > FYI, this error still exists in mainline (7f82f000ed030d1108b4de47d9e2d556092980c6).
> > 
> > Now it hit mainline (I can't be bothered to develop _new_ code to 
> > fix things in -next ;-), I'm implementing irqs_disabled_flags() for 
> > m68k. Stay tuned...
> 
> this (now mainline) commit should have fixed it:
> 
>  9244489: ftrace: handle archs that do not support irqs_disabled_flags
> 
> can you still see problems?

Yes, the "undefined reference to `save_stack_trace'", as already pointed out
by Al. I'm trying his fix now...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
