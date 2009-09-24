Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZIXPkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZIXPkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZIXPkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:40:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbZIXPkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:40:08 -0400
Date: Thu, 24 Sep 2009 11:39:01 -0400
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Immediate values
Message-ID: <20090924153900.GB2648@redhat.com>
References: <20090924123154.GA12907@Krystal> <20090924123428.GA27282@elte.hu> <20090924140228.GA2648@redhat.com> <4ABB7F58.5030508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABB7F58.5030508@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 07:16:56AM -0700, H. Peter Anvin wrote:
> Jason Baron wrote:
>>
>> http://marc.info/?l=linux-kernel&m=125200966226921&w=2
>>
>> The basic idea is that gcc, 4.5 will have support for an 'asm goto'
>> construct which can refer to c code labels. Thus, we can replace a nop
>> in the code stream with a 'jmp' instruction to various branch targets.
>>
>
> Looking at the above, I'm a bit unclear for the need for a NOP5.  We  
> obviously need a *total* of 5 bytes, but at least I don't seem to  
> understand why we need 7 bytes per tracepoint.
>
> 	-hpa

that's right. The optimal solution doesn't require the the NOP5 at all,
and I've been playing around with an implementation that doesn't have
it. The problem I've been running into is that sometimes the compiler
will put in a short jump - '0xeb', with a 1 byte offset, but the jump
target is further away. Thus, I need to either ensure the target is
close, or somehow force a longer jump '0xe9' into the code so I always
have the space. The other advantage of not including the nop is easier
support for all x86 implementations, since I'm not sure a 5 byte atomic
nop is always available, whereas a jump is always atomic. I'm pretty
sure we can come up with a patch that avoids the nop...I'll keep working
on it.

thanks,

-Jason
