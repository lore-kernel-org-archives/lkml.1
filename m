Return-Path: <linux-kernel-owner+w=401wt.eu-S933229AbZKXPs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbZKXPs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbZKXPs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:48:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099AbZKXPs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:48:57 -0500
Message-ID: <4B0BFFD0.2080203@redhat.com>
Date: Tue, 24 Nov 2009 15:46:24 +0000
From: Andrew Haley <aph@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "H.J. Lu" <hjl.tools@gmail.com>,
       rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
 messing with mcount prologue
References: <1258694593.22249.1012.camel@gandalf.stny.rr.com> <1258736456.22249.1032.camel@gandalf.stny.rr.com> <4B06EF6F.2050507@redhat.com> <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com> <4B0972C9.302@redhat.com> <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com> <4B0BF119.4070704@redhat.com> <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain> <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com> <4B0BFC84.7070806@redhat.com> <20091124153634.GK22813@hs20-bc2-1.build.redhat.com>
In-Reply-To: <20091124153634.GK22813@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jelinek wrote:
> On Tue, Nov 24, 2009 at 03:32:20PM +0000, Andrew Haley wrote:
>> Jakub Jelinek wrote:
>>> On Tue, Nov 24, 2009 at 03:55:49PM +0100, Thomas Gleixner wrote:
>>>>> you should compile your code with -maccumulate-outgoing-args, and there's
>>>>> no need to use -mtune=generic.  Is that right?
>>>> Seems to work. What other side effects has that ?
>>> Faster code, significant increase in code size though.
>> Does it affect code size when we don't have to realign the stack pointer?
> 
> Yes, a lot.  The difference is that -maccumulate-outgoing-args allocates
> space for arguments of the callee with most arguments in the prologue, using
> subtraction from sp, then to pass arguments uses movl XXX, 4(%esp) etc.
> and the stack pointer doesn't usually change within the function (except for
> alloca/VLAs).
> With -mno-accumulate-outgoing-args args are pushed using push instructions
> and stack pointer is constantly changing.

Alright.  So, it is possible in theory for gcc to generate code that
only uses -maccumulate-outgoing-args when it needs to realign SP.
And, therefore, we could have a nice option for the kernel: one with
(mostly) good code density and never generates the bizarre code
sequence in the prologue.

Andrew.
