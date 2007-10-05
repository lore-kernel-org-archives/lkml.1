Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbXJEAMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbXJEAMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 20:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759553AbXJEAMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 20:12:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757930AbXJEAMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 20:12:43 -0400
Date: Thu, 4 Oct 2007 17:12:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
cc: Mathieu Chouquet-Stringer <mchouque@free.fr>, Ollie Wild <aaw@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
In-Reply-To: <18181.26846.253191.684845@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.0.999.0710041707260.23684@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <m3wsu2u7y6.fsf@bigip.mine.nu> <alpine.LFD.0.999.0710041023480.23684@woody.linux-foundation.org>
 <20071004204443.GA28483@bigip.bigip.mine.nu>
 <alpine.LFD.0.999.0710041413020.23684@woody.linux-foundation.org>
 <18181.26846.253191.684845@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Oct 2007, Paul Mackerras wrote:
> Linus Torvalds writes:
> > 
> > Well, since others definitely don't see this, including me, and I can do 
> > things like 62MB exec arrays:
> > 
> > 	[torvalds@woody linux]$ echo $(find /home/torvalds/) | wc
> > 	      1  883304 63000962
> 
> That wouldn't actually do an exec, assuming you're using bash, since
> echo is a shell builtin in bash.  You'd need to do /bin/echo.

Right you are, silly me. But yes, it works for me even with that (and 
since I downloaded the gcc source tree, it now has six more megs of 
arguments).

I also tested that "ulimit -s" seems to do the right thing for me.

I'm also assuming Mathieu is running x86 (or x86-64): HP-PA has a stack 
that grows upwards, and that has traditionally been exciting.

IA64 also has some strange things for the register backing store.

			Linus
