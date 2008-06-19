Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbYFSOcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbYFSOcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYFSOcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:32:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:31473 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYFSOcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:32:05 -0400
Message-Id: <485A8A16.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 19 Jun 2008 15:32:22 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: remove unnecessary ptregs call stubs
References: <485910B3.76E4.0078.0@novell.com>
 <20080619122538.GH7640@elte.hu> <485A5606.6080600@firstfloor.org>
In-Reply-To: <485A5606.6080600@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 19.06.08 14:50 >>>
>Ingo Molnar wrote:
>> * Jan Beulich <jbeulich@novell.com> wrote:
>> 
>>> A few of the ptregs call stubs are superfluous these days - the called 
>>> functions don't have a trailing 'struct pt_regs *' parameter anymore.
>> 
>> applied to tip/x86/cleanups - thanks Jan.
>
>Just want to point out that not having a pt_regs * argument is not necessarily
>sufficient for not needing a ptregs stub. Some code also accesses ptregs directly
>through the stack top from get_thread_info() and might assume a full one. That said I *think*
>it's ok for sigsuspend et.al. as in Jan's patch, but I haven't audited the complete code paths
>in question that they never do that.
>
>Would be good to clarify that in the commit log.

Looking at both the source and disassembly of sys_rt_sigsuspend() and
sys32_sigsuspend(), I cannot see anything pt_regs related. All these
functions call are copy_from_user(), spin_lock_irq(), recalc_sigpending(),
and schedule(), and besides that they just update some global and task
state.

Jan

