Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYHFNCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYHFNCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYHFNB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:01:58 -0400
Received: from main.gmane.org ([80.91.229.2]:40398 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbYHFNB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:01:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Date: Wed, 06 Aug 2008 09:11:47 -0400
Message-ID: <4899A313.7020708@tmr.com>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>	<Pine.LNX.4.64.0808051140150.6309@anakin>	<33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>	<200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: pool-68-236-140-141.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <87r6926dsr.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
>> Seriously? Because it doesn't seem to have had enough peer review,
>> it hasn't had widespread testing in somewhere like linux-next or
>> -mm, and we already have kgdb so you have to also explain why you
>> can't improve kgdb in the areas it trails mdb.
>>
>> But the ideal outcome would be if you could contribute patches to
>> kgdb to the point where it is as good as mdb. It is already in the
> 
That idea sounds familiar, the "suspend2" response, when something new 
and significantly different is offered, instead of putting it in and 
letting people choose in configuration, take the position that what is 
there is good enough, and if the author of the new solution will just 
drop all their ideas and slap some band-aids on the existing code it 
will be "gooder enough" without actually offering people a choice of 
something different.

And Andi explains just *why* this is different (and in many cases better):
> I don't think kgdb and a simple assembler debugger 
> are directly comparable. kgdb always requires a remote machine,
> which has many advantages, but is also often very inconvenient
> or impossible to arrange. An low overhead assembler debugger
> can be always compiled in just in case.
> 
I totally agree with this, the whole idea of a remote machine implies 
that the ability to connect is not what you are debugging.

> Also at least for the x86 port the debugger interfaces should
> be general enough now (see die hooks as a "debug vfs") that it would
> be quite possible to have a multitude of debuggers just using 
> them. In fact that's already the cases, kprobes and kgdb and 
> kdump are all kinds of debuggers using such hooks.
> 
> As long as it doesn't impact the core code and the mdb 
> code itself is considered merge worthy and has clean interfaces 
> that would seem fine to me.It essentially would just live somewhere in 
> its own directory using the existing interfaces. My standard
> test for seeing if a debugger has clean interfaces is to see
> if it can be loaded as a module.
> 
> There are enough different debugging styles around that offering
> developers different tools of which they can pick whatever suits
> them is not a bad idea. Also as everyone knows debugging
> is often a major time eater and if more tools are available that 
> can only help the kernel.
> 
In addition to "Bravo!" I will add that tools which work somewhat 
differently will increase the chances of having a tool which will work 
at all, depending on what's being investigated.

> That said I haven't read the mdb code, not judging on its general
> merge-worthiness or am really completely sure what are all the details
> of a "netware style debugger", just a general high level comment on
> debuggers. At least judging based on the patch sizes it at least
> doesn't seem particularly bloated.  But of course it would need full
> proper review first.
> 
I would suggest that if it meets coding standards and doesn't break 
anything else it could be included in -mm (assume there's no objection 
there) and let people beat on it there, with the assumption that unless 
problems are found it will be promoted.

The need for a special setup make spur-of-the-moment investigation of 
unusual behavior difficult for anyone but a hard-core developer who does 
daily work on a setup with the remote machine available at hand. I think 
this new approach would encourage people to do quick checks when the 
behavior is observed.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

