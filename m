Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbXBVTnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbXBVTnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXBVTnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:43:11 -0500
Received: from raven.upol.cz ([158.194.120.4]:43389 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbXBVTnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:43:10 -0500
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: x86 hardware and transputers (Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
In-Reply-To: <f2b55d220702220059t7487a0a4mbe88b91dc033de4b@mail.gmail.com>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221225711.GB32031@elte.hu> <f2b55d220702211653x69718ef4o2dd62ed3156465b0@mail.gmail.com> <20070222065125.GA862@elte.hu> <f2b55d220702220059t7487a0a4mbe88b91dc033de4b@mail.gmail.com>
Date: Thu, 22 Feb 2007 20:52:40 +0100
Message-Id: <E1HKJzc-0001pk-Fe@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: "Michael K. Edwards"
> Newsgroups: gmane.linux.kernel
> Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
> Date: Thu, 22 Feb 2007 00:59:10 -0800

[striping cc list]

[]
> On 2/21/07, Ingo Molnar <mingo@elte.hu> wrote:
>> > [...] As for threadlets, making them kernel threads is not such a good
>> > design feature, O(1) scheduler or not.  You take the full hit of
>> > kernel task creation, on the spot, for every threadlet that blocks.
>> > [...]
>>
>> this is very much not how they work. Threadlets share the same basic
>> infrastructure with syslets and they do /not/ take a 'full hit of kernel
>> thread creation' when they block. Please read the announcements, past
>> discussions on lkml and the code about how it works.
[]
> Yes, I will go back and read the code for myself.  This will take me
> some time because I have only a hand-waving level of knowledge about
> task_structs and pt_regs, and have largely avoided the dark corners of
> the x86 architecture.

This architecture was brought to us by windows on our screens. And it
took years (a decade?) for them to use all hardware features:

     	      (IA-32, i386) --> (MS Windows NT,9X)

Yet you must still do much system programming to use that features.

While

> But I think my point still stands: allowing code inside threadlets to
> use the usual C library wrappers around the usual synchronous syscalls
> is going to mean that the threadlet context is fairly heavyweight, both
> in memory and CPU/MMU state.  This means that you can't pull it cheaply
> over to whatever CPU core happened to process the device I/O that
> delivered the data it wanted.
[]
> Oh, and while I haven't written a kernel or an RDBMS, I have written
> some fairly serious non-blocking I/O code (without resorting to
> threads; one socket and thousands of independent userspace state
> machines) and rewritten the plumbing of two fairly heavy-duty network
> operations frameworks, one of them attached to a horrifically complex
> GUI.  And briefly, long ago, I made Transputers dance with Occam and
> galaxies spin with PVM.

transputers were (AFAIK) completely orthogonal to any today's x86 CPU
architecture -- hardware parallelism, special programming language and
technique to match this hardware. And they were chosen to work on Mars in
mid-90th, while crowd wanted more stupid windows on cheap CPUs.

> This gives me exactly zero credentials here, of course, but may suggest
> to you that when I say something that seems naive, it's more likely
> that I got the Linux-specific lingo wrong. That, or I'm _actively_
> stupid.  :-)

Thus, i think, you are thinking mostly on hardware level, while it's
longstanding software problem, i.e. to use x86 (:.

Regards.
--
-o--=O`C
 #oo'L O
<___=E M
