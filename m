Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZKSSig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZKSSig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZKSSif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:38:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbZKSSif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:38:35 -0500
Message-ID: <4B05903B.5080708@redhat.com>
Date: Thu, 19 Nov 2009 18:36:43 +0000
From: Andrew Haley <aph@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>	 <20091119072040.GA23579@elte.hu>	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>	 <4B058C76.9090609@redhat.com> <1258655585.22249.751.camel@gandalf.stny.rr.com>
In-Reply-To: <1258655585.22249.751.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2009-11-19 at 18:20 +0000, Andrew Haley wrote:
> 
>> OK, I found it.  There is a struct defined as
>>
>> struct entry {
>>  ...
>> } __attribute__((__aligned__((1 << (4)))));
>>
>> and then in timer_stats_update_stats you have a local variable of type
>> struct entry:
>>
>> void timer_stats_update_stats()
>> {
>>  spinlock_t *lock;
>>  struct entry *entry, input;
>>
>> So, gcc has to 16-align the stack pointer to satisfy the alignment
>> for struct entry.
> 
> It has to align the entire stack? Why not just the variable within the
> stack?

How?. gcc has to know, at compile time, the offset from sp of each variable.
So, it of course makes sure that offset is 16-aligned, but it also has to
16-align the stack pointer.

Andrew.
