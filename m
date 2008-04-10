Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYDJOzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYDJOzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbYDJOzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:55:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbYDJOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:55:45 -0400
Date: Thu, 10 Apr 2008 10:55:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@shadowen.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
In-Reply-To: <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0804101054010.5673@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com>
 <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org>
 <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
 <20080410144114.GH10019@one.firstfloor.org>
 <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 10 Apr 2008, Linus Torvalds wrote:
>
> But maybe we can see it in the resulting object file somehow, and do the
> check there (the same way we do the init-section analysis). I assume the
> ..size directive writes some debug info or similar, and we can create a big
> warning when a size is unexpectedly huge and crosses section size
> boundaries?

I'm not sure how much this would help, but where I saw my red flag was
examining the objdump and seeing this:

  89:   bf 69 00 00 00          mov    $0x69,%edi
  8e:   e8 00 00 00 00          callq  93 <alternatives_smp_module_add+0x30>
                        8f: R_X86_64_PC32       .rodata+0x8c


A call to .rodata??

-- Steve

