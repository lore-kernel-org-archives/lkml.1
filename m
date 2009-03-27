Return-Path: <linux-kernel-owner+w=401wt.eu-S1751233AbZC0ECy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbZC0ECy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 00:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZC0ECo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 00:02:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbZC0ECo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 00:02:44 -0400
Date: Thu, 26 Mar 2009 20:59:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <alpine.LFD.2.00.0903262035270.3994@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903262044050.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
 <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0903262035270.3994@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Linus Torvalds wrote:
> 
> We should aim to get it right. The "user space can tweak any numbers they 
> want" is ALWAYS THE WRONG ANSWER. It's a cop-out, but more importantly, 
> it's a cop-out that doesn't even work, and that just results in everybody 
> having different setups. Then nobody is happy.

In fact it results in "everybody" just having the distro defaults, which 
in some cases then depend on things like which particular version they 
initially installed things with (because some decisions end up being 
codified in long-term memory by that initial install - like the size of 
the journal when you mkfs'd your filesystem, or the alignment of your 
partitions, or whatever).

The exception, of course, ends up being power-users that then tweak things 
on their own.

Me, I may be a power user, but I absolutely refuse to touch default 
values. If they are wrong, they should be fixed. I don't want to add 
"relatime" to my /etc/fstab, because then the next time I install, I'll 
forget - and if I really need to do that, then the kernel should have 
already done it for me as the default choice.

I also don't want to say that "Fedora should just do it right" (I'll 
complain about things Fedora does badly, but not setting magic values in 
/proc is not one of them), because then even if Fedora _were_ to get 
things right, others won't. Or even worse, somebody will point that SuSE 
or Ubuntu _did_ do it right, but the distro I happen to use is doing the 
wrong thing.

And yes, I could do my own site-specific tweaks, but again, why should I?  
If the tweak really is needed, I should put it in the generic kernel. I 
don't do anything odd. 

End result: regardless of scenario, depending on user-land tweaking is 
always the wrong thing. It's the wrong thing for distributions (they'd all 
need to do the exact same thing anyway, or chaos reigns, so it might as 
well be a kernel default), and it's the wrong thing for individuals 
(because 99.9% of individuals won't know what to do, and the remaining 
0.1% should be trying to improve _other_ peoples experiences, not just 
their own!).

The only excuse _ever_ for user-land tweaking is if you do something 
really odd. Say that you want to get the absolutely best OLTP numbers you 
can possibly get - with no regards for _any_ other workload. In that case, 
you want to tweak the numbers for that exact load, and the exact machine 
that runs it - and the result is going to be a totally worthless number 
(since it's just benchmarketing and doesn't actually reflect any real 
world scenario), but hey, that's what benchmarketing is all about.

Or say that you really are a very embedded environment, with a very 
specific load. A router, a cellphone, a base station, whatever - you do 
one thing, and you're not trying to be a general purpose machine. Then you 
can tweak for that load. But not otherwise.

If you don't have any magical odd special workloads, you shouldn't need to 
tweak a single kernel knob. Because if you need to, then the kernel is 
doing something wrong to begin with.

			Linus
