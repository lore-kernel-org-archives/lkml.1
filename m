Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZKSTLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZKSTLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZKSTLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:11:15 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3318 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZKSTLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:11:15 -0500
Message-ID: <4B05982B.6060200@caviumnetworks.com>
Date: Thu, 19 Nov 2009 11:10:35 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>   <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>   <20091119072040.GA23579@elte.hu>   <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>    <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>   <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>   <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>   <1258653562.22249.682.camel@gandalf.stny.rr.com>  <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com> <4B058CCD.8050605@redhat.com> <alpine.LFD.2.00.0911191039470.2793@localhost.localdomain> <alpine.LFD.2.00.0911191041471.2793@localhost.localdomain> <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911191047350.2793@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2009 19:10:36.0035 (UTC) FILETIME=[F959B530:01CA694B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 19 Nov 2009, Linus Torvalds wrote:
>> I bet other people than just the kernel use the mcount hook for subtler 
>> things than just doing profiles. And even if they don't, the quoted code 
>> generation is just crazy _crap_.
> 
> For the kernel, if the only case is that timer_stat.c thing that Thomas 
> pointed at, I guess we can at least work around it with something like the 
> appended. The kernel code is certainly ugly too, no question about that. 
> 
> It's just that we'd like to be able to depend on mcount code generation 
> not being insane even in the presense of ugly code..
> 
> The alternative would be to have some warning when this happens, so that 
> we can at least see it. "mcount won't work reliably"
> 

For the MIPS port of GCC and Linux I recently added the 
-mmcount-ra-address switch.  It causes the location of the return 
address (on the stack) to be passed to mcount in a scratch register.

Perhaps something similar could be done for x86.  It would make this 
patching of the return location more reliable at the expense of more 
code at the mcount invocation site.

For the MIPS case the code size doesn't increase, as it is done in the 
delay slot of the call instruction, which would otherwise be a nop.

David Daney
