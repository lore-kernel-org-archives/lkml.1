Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbYDJSkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbYDJSkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYDJSkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:40:02 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56562 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYDJSkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:40:00 -0400
Date: Thu, 10 Apr 2008 20:40:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@shadowen.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
Message-ID: <20080410184027.GA21893@uranus.ravnborg.org>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com> <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org> <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com> <20080410144114.GH10019@one.firstfloor.org> <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org> <Pine.LNX.4.58.0804101054010.5673@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0804101054010.5673@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 10:55:44AM -0400, Steven Rostedt wrote:
> 
> On Thu, 10 Apr 2008, Linus Torvalds wrote:
> >
> > But maybe we can see it in the resulting object file somehow, and do the
> > check there (the same way we do the init-section analysis). I assume the
> > ..size directive writes some debug info or similar, and we can create a big
> > warning when a size is unexpectedly huge and crosses section size
> > boundaries?
> 
> I'm not sure how much this would help, but where I saw my red flag was
> examining the objdump and seeing this:
> 
>   89:   bf 69 00 00 00          mov    $0x69,%edi
>   8e:   e8 00 00 00 00          callq  93 <alternatives_smp_module_add+0x30>
>                         8f: R_X86_64_PC32       .rodata+0x8c
> 
> 
> A call to .rodata??
Did you have any relocation record reflecting this reference?
The init_section stuff today rely purely on relocation
records and is easy to extend.

	Sam
