Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZKVRVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZKVRVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 12:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZKVRVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 12:21:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbZKVRVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 12:21:51 -0500
Message-ID: <4B0972C9.302@redhat.com>
Date: Sun, 22 Nov 2009 17:20:09 +0000
From: Andrew Haley <aph@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, jakub@redhat.com,
       gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC
 	messing with mcount prologue
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>	 <20091119072040.GA23579@elte.hu>	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>	 <1258694593.22249.1012.camel@gandalf.stny.rr.com>	 <1258736456.22249.1032.camel@gandalf.stny.rr.com>	 <4B06EF6F.2050507@redhat.com> <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com>
In-Reply-To: <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H.J. Lu wrote:
> On Fri, Nov 20, 2009 at 11:35 AM, Andrew Haley <aph@redhat.com> wrote:
>> Steven Rostedt wrote:
>>> Ingo, Thomas and Linus,
>>>
>>> I know Thomas did a patch to force the -mtune=generic, but just in case
>>> gcc decides to do something crazy again, this patch will catch it.
>>>
>>> Should we try to get this in now?
>> I'm sure this makes sense, but a gcc test case would be even better.
>> If this can be detected in the gcc test suite it'll be found and
>> fixed long before y'all in kernel land get to see it.  That's the
>> only way to guarantee this never bothers you again.
>>
>> H.J., who wrote the code in question, is hopefully looking at why
>> this odd code is being generated.  Once he's done I can put a
>> suitable test case in the gcc test suite.
>>
> 
> See:
> 
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=42109#c7

I saw that, but does it mean you're going to investigate?  There is
no obvious reason why -mtune=generic should affect code generation
in this way, but it does.

Andrew.
