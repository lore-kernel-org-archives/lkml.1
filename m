Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZABKdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZABKdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZABKcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:32:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:26714 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbZABKcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:32:50 -0500
Cc: Rob Landley <rob@landley.net>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Message-Id: <2D4EECE3-784E-4853-BF6E-B0915C15EC02@mirell.org>
From: Mark Miller <mark@mirell.org>
To: Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20090102095023.GA28078@linux-sh.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Fri, 2 Jan 2009 04:32:42 -0600
References: <200901020207.30359.rob@landley.net> <20090102095023.GA28078@linux-sh.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 2, 2009, at 3:50 AM, Paul Mundt wrote:

> On Fri, Jan 02, 2009 at 02:07:28AM -0600, Rob Landley wrote:
>> Before 2.6.25 (specifically git  
>> bdc807871d58285737d50dc6163d0feb72cb0dc2 )
>> building a Linux kernel never required perl to be installed on the  
>> build
>> system.  (Various development and debugging scripts were written in  
>> perl and
>> python and such, but they weren't involved in actually building a  
>> kernel.)
>> Building a kernel before 2.6.25 could be done with a minimal system  
>> built from
>> gcc, binutils, bash, make, busybox, uClibc, and the Linux kernel,  
>> and nothing
>> else.  (Embedded developers creating clean cross compile  
>> environments that
>> won't leak bits of the host system into the target, or  
>> bootstrapping native
>> development environments to run on target hardware or under  
>> emulators, tend to
>> care about this sort of thing.)
>>
>> The perl checkin for 2.6.25 was the camel's nose under the tent  
>> flap, and
>> since then two more instances of perl have shown up in the core  
>> kernel build.
>> This patch series removes the three required to build a basic  
>> kernel for qemu
>> for the targets I've tested (arm, mips, powerpc, sparc, m68k, sh4,  
>> and of
>> course x86 and x86-64), replacing them with shell scripts.
>
> Misguided rhetoric aside, what does this actually accomplish? If folks
> add meaningful tools in to the kernel that require python, and it is
> generally regarded as being fairly ubiquitous, I can't imagine there
> being any substantiated objections against it.

And if the said meaningful tools introduce complex dependencies, then  
there should be an open discussion as to why exactly we need those  
tools as opposed to a simpler implementation.

> Your main reasons against inclusion of perl seem to be that there is  
> no
> realistic expectation for target systems that will be self-hosting  
> will
> have perl included, or the inherent complexity in maintaining a  
> coherent
> cross compiling environment. Both of these things are issues with your
> own environment, and in no way are these representative of the  
> embedded
> development community at large.

I feel that if you attempted to look for discussions on "cross- 
compiling perl", you will meet with a variety of complaints on what a  
nightmare it is to do so in a sandboxed environment.

> Now with that out of the way, this entire series fundamentally fails  
> to
> convert half of the perl scripts shipped with the kernel today, some  
> that
> are required for build depending on Kconfig options, and others that  
> are
> simply useful tools for self-hosted environments. Simply converting a
> couple of scripts over you find objectionable is certainly fine if  
> there
> is a real benefit in doing so, but this doesn't actually accomplish  
> your
> goal of removing the perl dependency.

 From what I can tell, it allows one to fully build the Linux kernel  
without Perl. Without these series of patches, to actually *build* the  
kernel, one requires Perl. Unless there is an alternate way to do  
"make headers_install" that I am not seeing, that appears to now be  
done in Perl. All the other Perl scripts were merely nice to have, not  
necessary to build a Linux kernel.

> Ignoring the compile-time dependencies that you overlooked, what you
> define as "development and debugging" scripts are still an integral  
> part
> of the system, unless you are trying to argue that embedded developers
> have no interest in things like checkstack due to the trouble of  
> trying
> to get perl built.

Do I need that to compile a kernel? No.

> Until you can post a series that converts all of scripts/*.pl in its
> entirety, you have failed to address the fundamental reason why perl  
> is
> used in the first place. Trying to toss bizarre policy statements  
> around
> regarding things you personally find objectionable without any  
> coherent
> technical argument to the contrary is of no constructive use  
> whatsoever.

Perl was not required to build the Linux kernel. Now it is. It adds  
another dependency to the Linux kernel. Requiring bash is far less a  
dependency that Perl is.

> The kernel is and always has been about using the right tool for the  
> job,
> not a matter of dictating what tools you must use in order to  
> accomplish
> a task you are interested in. Common sense does apply here though, so
> this might be a more daunting task for some than others.

How is Perl a better tool for the job than what currently bash and  
other standard utilities already offer?

--
Mark Miller
mark@mirell.org




