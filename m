Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbZKXQmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbZKXQmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933508AbZKXQms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:42:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933520AbZKXQmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:42:45 -0500
Message-ID: <4B0C0C12.7040907@zytor.com>
Date: Tue, 24 Nov 2009 08:38:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Haley <aph@redhat.com>
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
References: <1258694593.22249.1012.camel@gandalf.stny.rr.com> <1258736456.22249.1032.camel@gandalf.stny.rr.com> <4B06EF6F.2050507@redhat.com> <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com> <4B0972C9.302@redhat.com> <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com> <4B0BF119.4070704@redhat.com> <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain> <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com> <4B0BFC84.7070806@redhat.com> <20091124153634.GK22813@hs20-bc2-1.build.redhat.com> <4B0BFFD0.2080203@redhat.com>
In-Reply-To: <4B0BFFD0.2080203@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2009 07:46 AM, Andrew Haley wrote:
>>
>> Yes, a lot.  The difference is that -maccumulate-outgoing-args allocates
>> space for arguments of the callee with most arguments in the prologue, using
>> subtraction from sp, then to pass arguments uses movl XXX, 4(%esp) etc.
>> and the stack pointer doesn't usually change within the function (except for
>> alloca/VLAs).
>> With -mno-accumulate-outgoing-args args are pushed using push instructions
>> and stack pointer is constantly changing.
> 
> Alright.  So, it is possible in theory for gcc to generate code that
> only uses -maccumulate-outgoing-args when it needs to realign SP.
> And, therefore, we could have a nice option for the kernel: one with
> (mostly) good code density and never generates the bizarre code
> sequence in the prologue.
> 

If we're changing gcc anyway, then let's add the option of intercepting
the function at the point where the machine state is well-defined by
ABI, which is before the function stack frame is set up.

-maccumulate-outgoing-args sounds like it would be painful on x86 (not
using its cheap push/pop instructions), but I guess since it's only when
tracing it's less of an issue.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

