Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZFWHna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZFWHna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbZFWHnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:43:23 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:45331 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZFWHnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:43:23 -0400
Message-ID: <4A408774.9010401@linux.vnet.ibm.com>
Date: Tue, 23 Jun 2009 09:42:44 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcov: enable GCOV_PROFILE_ALL for x86_64
References: <200906182200.n5IM0jFq007278@hera.kernel.org> <20090620101424.GA21928@elte.hu> <4A3F6AD5.1030703@linux.vnet.ibm.com> <20090622105609.GA17456@elte.hu>
In-Reply-To: <20090622105609.GA17456@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> the GCOV code cannot be enabled in distros right now, due to the 
> high compiler-generated overhead, and due to the fact that the gcov 
> data structures used are single threaded. (which makes a gcov 
> enabled kernel very slow on SMP, due to the global cacheline 
> bounces)

I definitely agree that the gcov kernel support shouldn't be active on 
distro kernels. In my opinion that is also not a strict requirement for 
code coverage testing. If you're only looking at the resulting overall 
coverage rate, than yes, having the mechanism active all the time would 
be a good thing. But the real use of code coverage testing lies in being 
able to look at what parts of the code are not hit by a test case. That 
requires preparation (getting the source) and focus on one kernel 
version. So in my opinion, the extra effort of building and installing 
the instrumented kernel is not a limiting factor.

> IMO it would be _much_ better to implement hardware-assisted 
> call-graph tracking:
> 
>  - Use the BTS (Branch Trace Store) facilities to hardware-sample 
>    all branches+calls (optionally, dynamically enable-able)
> 
>  - Post-process the raw branch trace information (in the kernel
>    BTS-overflow irq handler) to calculate call-coverage information.
> 
> Unlike the unconditional GCC based GCOV stuff that is currently 
> upstream, BTS tracing is supported by a large range of hardware and 
> it can be enabled _transparently_, so it could be built in and 
> enabled by distros too, to test code coverage.

This is a very interesting idea. You could get branch level coverage 
information out of this. Some open questions that I could think of:
* how to map branch addresses to source code lines
* how to determine how many branches there are during initialization to 
allocate enough resources

> Would you be interested in looking at (and implementing) this?

While it sounds tempting, I don't think that I can spare the time to 
effectively work on this, so I'll have to decline.

