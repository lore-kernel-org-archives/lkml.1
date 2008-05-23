Return-Path: <linux-kernel-owner+w=401wt.eu-S1763859AbYEWAh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763859AbYEWAh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 20:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbYEWAhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 20:37:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759220AbYEWAhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 20:37:46 -0400
Message-ID: <483610DA.7010606@zytor.com>
Date: Thu, 22 May 2008 17:33:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       roland@redhat.com, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <20080518013416.GB30034@linux-os.sc.intel.com>	<18481.37905.297556.288317@harpo.it.uu.se>	<20080520015723.GD30034@linux-os.sc.intel.com>	<4832A173.6020203@firstfloor.org>	<18482.53246.642835.894623@harpo.it.uu.se>	<4832E705.2010900@zytor.com>	<18482.60491.764019.292031@harpo.it.uu.se>	<20080520175325.GE30034@linux-os.sc.intel.com>	<4834BE39.2000904@zytor.com>	<18485.13663.51624.694435@harpo.it.uu.se>	<20080522205619.GB7998@linux-os.sc.intel.com>	<4835DF64.6080104@zytor.com> <18485.62848.335125.152538@harpo.it.uu.se>
In-Reply-To: <18485.62848.335125.152538@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> 
>  > > While restoring from the user, kernel also need to find out what layout
>  > > the user is passing. So it's bi-directional. I prefer the same mechanism
>  > > (using cookies/magic numbers etc inaddition to uc_flags or cpuid checks) to
>  > > interpret the fpstate for both user/kernel.
>  > 
>  > No, it really doesn't: the kernel only needs to be able to read the same 
>  > format as it itself wrote.
> 
> The kernel needs to accept one(*) of the formats it can produce, which
> is not necessarily what it last produced. It's not inconceivable that
> user-space will construct sigframes on the fly (to emulate setcontext),
> or that it will mangle sigframes (e.g. to map non-rt to rt before sigreturn).
> 
> (*) The format is determined by which version of sys_sigreturn the
> user invokes.
> 

No.  You CANNOT restore from a frame that doesn't have the full state - 
you don't have enough information to do so!

	-hpa

