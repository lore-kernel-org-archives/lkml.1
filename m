Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbZKYVBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbZKYVBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbZKYVBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:01:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbZKYVBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:01:50 -0500
Message-ID: <4B0D9AF3.6000702@redhat.com>
Date: Wed, 25 Nov 2009 21:00:35 +0000
From: Andrew Haley <aph@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jakub Jelinek <jakub@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H.J. Lu" <hjl.tools@gmail.com>,
       rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
 messing with mcount prologue
References: <1258736456.22249.1032.camel@gandalf.stny.rr.com> <4B06EF6F.2050507@redhat.com> <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com> <4B0972C9.302@redhat.com> <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com> <4B0BF119.4070704@redhat.com> <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain> <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com> <alpine.LFD.2.00.0911251604280.24119@localhost.localdomain> <20091125154452.GA9456@elte.hu> <20091125164434.GS22813@hs20-bc2-1.build.redhat.com> <4B0D8FC1.1010608@zytor.com>
In-Reply-To: <4B0D8FC1.1010608@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 11/25/2009 08:44 AM, Jakub Jelinek wrote:
>> If you compile kernels 90%+ people out there run with -p on i?86/x86_64,
>> then certainly coming up with a new gcc switch and new profiling ABI is
>> desirable.  -p on i?86/x86_64 e.g. forces -fno-omit-frame-pointer, which
>> makes code on these register starved arches significantly worse.
>> Making GCC output profiling call before prologue instead of after prologue
>> is a 4 liner in generic code and a few lines in target specific code.
>> The important thing is that we shouldn't have 100 different profiling ABIs,
>> so it is desirable to agree on something that will be generally useful not
>> just for the kernel, but perhaps for other purposes.
> 
> There is really just one that makes sense, which is providing the
> ABI-defined entry state, which means intercepting at the point of entry.
> 
> Anything else is/was a mistake.

Indeed.  The problem, though, is that the "naked call" approach, while attractive,
requires the back end to be modified and so requires the help of the gcc maintainers
for every Linux target.  Not that this is a terrible idea, but such co-ordination
is going to take time.

Andrew.
