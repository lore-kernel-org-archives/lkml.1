Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbYBLOEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbYBLOEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbYBLOEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:04:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43637 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032AbYBLOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:04:24 -0500
Date: Tue, 12 Feb 2008 15:39:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212143949.GA2258@one.firstfloor.org>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <47B19F67.5050105@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B19F67.5050105@windriver.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 07:30:15AM -0600, Jason Wessel wrote:
> This is not a technical argument, but I am not a big fan of hard hanging
> the system if you cannot sync all the CPUs. 

Me neither.

> We might be best served to add a comment to explain the purpose of
> kgdb_arch_pc() and put it in the optional implementation function
> headers in include/linux/kgdb.h
> 
> On some archs certain exceptions do not report the address that the
> exception occurred at when you call instruction_pointer(). This optional
> function allows for an arch to perform a "fixup" to get the address the
> exception actually occurred at.

Shouldn't that be handled in the remote gdb?

> 
> Kgdb requires the actual exception address so a sanity check can be
> performed to make sure kgdb did not hit an exception while in a chunk of
> code kgdb requires for its functionality. If you hit one of these

That was for the old longjmp checks, but that code is long gone isn't it
and replacement with standard __ex_table handling.

> conditions kgdb makes its best attempt to try to "patch the wound"
> inflicted by shooting yourself but at least you get notified vs a silent
> hang :-)

In what cases is that still needed?

-Andi
