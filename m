Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbZH1Sdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbZH1Sdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZH1Sdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:33:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33398 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZH1Sdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:33:52 -0400
Date: Fri, 28 Aug 2009 14:33:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] lockup with the latest kernel
In-Reply-To: <alpine.DEB.2.00.0908281213180.3647@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0908281428180.3647@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0908191134260.12663@gandalf.stny.rr.com> <alpine.DEB.2.00.0908271836140.26718@gandalf.stny.rr.com> <4A9744F4.7010208@kernel.org> <alpine.LFD.2.00.0908272059320.7223@eeepc.linux-foundation.org>
 <alpine.DEB.2.00.0908281213180.3647@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 28 Aug 2009, Steven Rostedt wrote:
> On Thu, 27 Aug 2009, Linus Torvalds wrote:
> > > ...
> > > >> [13288.222084] EIP: 0060:[<c0110821>] EFLAGS: 00000002 CPU: 0
> > > >> [13288.222084] EIP is at default_send_IPI_mask_logical+0x53/0x92
> > 
> > Is this one perhaps fixed by b04e6373d694 ("x86: don't call 
> > '->send_IPI_mask()' with an empty mask")
> > 
> > It sounds a _lot_ like that bug. Older dual-cpu x86 box, and APIC getting 
> > confused by the occasional empty CPU mask, and then subsequent IPI's will 
> > hang.
> 
> I'll update my box to that kernel and see what happens and let you know.

I checked out the commit at b04e6373d694, compiled and booted that kernel. 
So far, so good. It survived logging into a gnome session (sometimes locks 
up there), and a full kernel compile (usually locks up there too). But 
there's been rare times that it would take days before hitting the bug.

I'll keep it in this kernel for a while and if it lasts the week, I'll 
consider it fixed. This box acts as my email, dhcp and web server, as well 
as one of the boxes in my distcc farm, thus it gets a bit of use. It will 
not be idle during this time period.

Thanks!

-- Steve

