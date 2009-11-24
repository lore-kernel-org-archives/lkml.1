Return-Path: <linux-kernel-owner+w=401wt.eu-S933659AbZKXRON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659AbZKXRON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933623AbZKXROL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:14:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933581AbZKXROI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:14:08 -0500
Message-ID: <4B0C13F4.5090106@redhat.com>
Date: Tue, 24 Nov 2009 17:12:20 +0000
From: Andrew Haley <aph@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jakub Jelinek <jakub@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H.J. Lu" <hjl.tools@gmail.com>, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
  messing with mcount prologue
References: <1258694593.22249.1012.camel@gandalf.stny.rr.com> <1258736456.22249.1032.camel@gandalf.stny.rr.com> <4B06EF6F.2050507@redhat.com> <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com> <4B0972C9.302@redhat.com> <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com> <4B0BF119.4070704@redhat.com> <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain> <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com> <4B0BFC84.7070806@redhat.com> <20091124153634.GK22813@hs20-bc2-1.build.redhat.com> <4B0BFFD0.2080203@redhat.com> <4B0C0C12.7040907@zytor.com>
In-Reply-To: <4B0C0C12.7040907@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 11/24/2009 07:46 AM, Andrew Haley wrote:
>>> Yes, a lot.  The difference is that -maccumulate-outgoing-args allocates
>>> space for arguments of the callee with most arguments in the prologue, using
>>> subtraction from sp, then to pass arguments uses movl XXX, 4(%esp) etc.
>>> and the stack pointer doesn't usually change within the function (except for
>>> alloca/VLAs).
>>> With -mno-accumulate-outgoing-args args are pushed using push instructions
>>> and stack pointer is constantly changing.
>> Alright.  So, it is possible in theory for gcc to generate code that
>> only uses -maccumulate-outgoing-args when it needs to realign SP.
>> And, therefore, we could have a nice option for the kernel: one with
>> (mostly) good code density and never generates the bizarre code
>> sequence in the prologue.
> 
> If we're changing gcc anyway, then let's add the option of intercepting
> the function at the point where the machine state is well-defined by
> ABI, which is before the function stack frame is set up.

Hmm.  On the x86 I suppose we could just inject a naked call instruction,
but not all aeches allow us to call anything before we've saved the return
address.  Or are you talking x86 only?

Andrew.

