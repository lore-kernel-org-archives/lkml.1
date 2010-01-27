Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708Ab0A0RsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0A0RsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490Ab0A0RsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:48:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43924 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab0A0RsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:48:18 -0500
Message-ID: <4B607B1A.3080007@zytor.com>
Date: Wed, 27 Jan 2010 09:42:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Tromey <tromey@redhat.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       utrace-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       JimKeniston <jkenisto@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: linux-next: add utrace tree
References: <20100121013822.28781960.sfr@canb.auug.org.au>	 <20100122005147.GD22003@redhat.com>	 <20100121170541.7425ff10.akpm@linux-foundation.org>	 <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>	 <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com>	 <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>	 <20100122221348.GA4263@redhat.com>	 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>	 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>	 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>	 <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>	 <m33a1tnbd9.fsf@fleche.redhat.com>	 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>	 <m3636oh2rt.fsf@fleche.redhat.com>	 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>	 <1264575134.4283.1983.camel@laptop>	 <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain> <1264600792.31321.464.camel@gandalf.stny.rr.com>
In-Reply-To: <1264600792.31321.464.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 05:59 AM, Steven Rostedt wrote:
> [ Added Arjan ]
> 
> On Wed, 2010-01-27 at 02:43 -0800, Linus Torvalds wrote:
>>
>> On Wed, 27 Jan 2010, Peter Zijlstra wrote:
>>>
>>> Right, so you're going to love uprobes, which does exactly that. The
>>> current proposal is overwriting the target instruction with an INT3 and
>>> injecting an extra vma into the target process's address space
>>> containing the original instruction(s) and possible jumps back to the
>>> old code stream.
>>
>> Just out of interest, how does it handle the threading issue?
>>
>> Last I saw, at least some CPU people were _very_ nervous about overwriting 
>> instructions if another CPU might be just about to execute them.
> 
> I think the issue was that ring 0 was never meant to do that, where as,
> ring 3 does it all the time. Doesn't the dynamic library modify its
> text?
> 

No, it has nothing to do with ring.  It has to do with modifying code
that another CPU could be executing at the same time, and with modifying
code on the same processor through another virtual alias (they are
different issues.)  The same issues apply regardless of the CPL of the
processor.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

