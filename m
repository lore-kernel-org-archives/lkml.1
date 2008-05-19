Return-Path: <linux-kernel-owner+w=401wt.eu-S1762403AbYESPI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762403AbYESPI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761624AbYESPE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:04:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36037 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761609AbYESPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:04:57 -0400
Message-ID: <483196F8.8000108@firstfloor.org>
Date: Mon, 19 May 2008 17:04:24 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <20080513011030.GA31448@linux-os.sc.intel.com>	<18477.35703.679574.760417@harpo.it.uu.se>	<20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se>
In-Reply-To: <18481.37905.297556.288317@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The de-facto ABI for signal delivery and sigreturn is unfortunately
> based on fairly fixed-layout structs on the stack (sigframes). The
> only flexibility there that I've found is the sigcontext's fpstate
> pointer which allows the fpstate to be located elsewhere.

One sure 100% compatible way would be to only change the signal layout once
the application used anything that needs XSAVE/XRSTOR. But implementing 
that would be likely complicated and I'm not sure it's worth it.

I don't remember that much breakage when the FXSAVE support was 
introduced on i386. That already changed these data structures.

> Another idea is that marking non-siginfo sigframes could be done
> by adding a sys_xsave_sigreturn() and letting those sigframes
> have a return address pointing to a vsyscall that invokes this
> new syscall.

That sounds easy enough. x86-64 right now doesn't use signal vsyscalls but
there is no principle reason it can't.

-Andi
