Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYILO1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYILO1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYILO1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:27:16 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37285 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbYILO1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:27:16 -0400
Date: Fri, 12 Sep 2008 18:32:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pierre Morel <pmorel@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, gregkh@suse.de,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 1/1] system call notification with self_ptrace
Message-ID: <20080912143225.GA108@tv-sign.ru>
References: <48C51439.7000706@linux.vnet.ibm.com> <20080909124302.GA139@tv-sign.ru> <48C7E3A9.3060602@linux.vnet.ibm.com> <20080910162008.GA401@tv-sign.ru> <48CA5E4F.2020600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CA5E4F.2020600@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pierre,

On 09/12, Pierre Morel wrote:
>
> You are right, the functionality can be implemented with the system call.
> But it means we have the overhead of a system call just to clear two bits,
> the TIF_SYSCALL_TRACE and the PTS_SELF.

Yes.

So you want to optimize the code for the (imho very exotic) functionality.
And again, the overhead of a system call is nothing compared to the signal
delivery. I bet this overhead won't be visible with any benchmark.

> On the other hand we have an overhead of one single "if" inside
> the handle_signal() function.

What if everyone who wants to add the new functionality will add one
single "if + code" to the core kernel just because he wants to add
a very minor optimization for his needs?

And you forgot about the maintaince overhead. You forgot that this extra
"if" uglifies/complicates the code.

This all is imho of course, and I'm not maintainer. But I promise I
will argue against this change forever ;)

> We can do the same with fork and ptrace, yes, but with a very big 
> overhead on each system call and this is why this patch is so usefull: 
> because with this patch you sit inside the thread when analysing it and 
> have a direct access to all data without the need of IPC, ptrace or any 
> task switch.
>
> I will provide a test program and plan to release a tracing tool based 
> on it.

Yes please, this would be very nice. Please do not count me, but I'm
afraid I am not alone who needs to really understand why this patch
is useful.

Oleg.

