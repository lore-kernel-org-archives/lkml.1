Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYFSMuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYFSMuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYFSMuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:50:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39184 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbYFSMuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:50:24 -0400
Message-ID: <485A5606.6080600@firstfloor.org>
Date: Thu, 19 Jun 2008 14:50:14 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86-64: remove unnecessary ptregs call stubs
References: <485910B3.76E4.0078.0@novell.com> <20080619122538.GH7640@elte.hu>
In-Reply-To: <20080619122538.GH7640@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jan Beulich <jbeulich@novell.com> wrote:
> 
>> A few of the ptregs call stubs are superfluous these days - the called 
>> functions don't have a trailing 'struct pt_regs *' parameter anymore.
> 
> applied to tip/x86/cleanups - thanks Jan.

Just want to point out that not having a pt_regs * argument is not necessarily
sufficient for not needing a ptregs stub. Some code also accesses ptregs directly
through the stack top from get_thread_info() and might assume a full one. That said I *think*
it's ok for sigsuspend et.al. as in Jan's patch, but I haven't audited the complete code paths
in question that they never do that.

Would be good to clarify that in the commit log.

-Andi
