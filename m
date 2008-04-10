Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYDJA0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYDJA0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYDJA0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:26:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYDJA0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:26:08 -0400
Message-ID: <47FD5D42.5000603@zytor.com>
Date: Wed, 09 Apr 2008 17:20:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com> <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 9 Apr 2008, Steven Rostedt wrote:
> 
>> gcc expects all toplevel assembly to return to the original section type.
>> The code in alteranative.c does not do this. This caused some strange bugs
>> in sched-devel where code would end up in the .rodata section and when
>> the kernel sets the NX bit on all .rodata, the kernel would crash when
>> executing this code.
>>
>> This patch adds a .previous marker to return the code back to the
>> original section.
>>
> 
> Oh, and this would not be complete without giving Andrew Pinski complete
> credit for telling me it wasn't a gcc bug but a bug in the toplevel asm
> code in the kernel. ;-)
> 

In many ways it's kind of silly for this even to be in assembly, since 
all it is is a sequence of comma-separated byte values; I guess it was 
the easiest way to deal with it given the ".byte" prefix, but still...

	-hpa
