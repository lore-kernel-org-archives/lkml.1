Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYDIXvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYDIXvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 19:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYDIXvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 19:51:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39236 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYDIXvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 19:51:14 -0400
Date: Wed, 9 Apr 2008 19:51:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
In-Reply-To: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 9 Apr 2008, Steven Rostedt wrote:

>
> gcc expects all toplevel assembly to return to the original section type.
> The code in alteranative.c does not do this. This caused some strange bugs
> in sched-devel where code would end up in the .rodata section and when
> the kernel sets the NX bit on all .rodata, the kernel would crash when
> executing this code.
>
> This patch adds a .previous marker to return the code back to the
> original section.
>

Oh, and this would not be complete without giving Andrew Pinski complete
credit for telling me it wasn't a gcc bug but a bug in the toplevel asm
code in the kernel. ;-)

-- Steve

