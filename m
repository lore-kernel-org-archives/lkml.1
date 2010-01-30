Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637Ab0A3SAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab0A3SAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509Ab0A3SAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:00:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480Ab0A3SAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:00:43 -0500
Date: Sat, 30 Jan 2010 09:59:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Tom Tromey <tromey@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-next@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       utrace-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
In-Reply-To: <1264873751.4561.9155.camel@frodo>
Message-ID: <alpine.LFD.2.00.1001300955570.4206@localhost.localdomain>
References: <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>  <m33a1tnbd9.fsf@fleche.redhat.com>  <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>  <m3636oh2rt.fsf@fleche.redhat.com>  <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
  <1264575134.4283.1983.camel@laptop> <20100127085442.GA28422@elte.hu>  <1264643539.5068.62.camel@localhost.localdomain>  <20100128085502.GA7713@elte.hu> <20100129045546.GA16920@in.ibm.com>  <20100129074241.GG14636@elte.hu>
 <1264873751.4561.9155.camel@frodo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Jan 2010, Steven Rostedt wrote:
> 
> The kernel is limited to what instructions it can perform, no floating
> point for example (of course there are some exceptions).

Actually, the reason the kernel is limited to not performing floating 
point instructions is that teh kernel doesn't own the floating point 
register set - it's too big to save/restore, so the kernel leaves it 
alone.

But for emulating an instruction from user space, it would be perfectly 
fine to do an FP instruction in kernel space, since we're explicitly doing 
it on behalf of user space, and with user space owning it.

Of course, that would require that we _only_ touch the registers that user 
space wants us to touch, which is likely impossible in practice for 
anything but an execute-out-of-line model.

> But generally, the instructions in the kernel should be easier to 
> emulate than in userspace.

Yeah, we control the kernel instructions better, and we know what the 
environment is. For example, we never have to worry about vm86 mode or 
segments when we fix up kernel instructions, but user space can do 
anything, of course.

			Linus
