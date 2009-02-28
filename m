Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZB1Co7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZB1Co7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZB1Cou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:44:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbZB1Cot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:44:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: mtk.manpages@gmail.com
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Linux API <linux-api@vger.kernel.org>, drepper@redhat.com
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
In-Reply-To: Michael Kerrisk's message of  Saturday, 28 February 2009 14:53:23 +1300 <cfd18e0f0902271753ld9b432tae6c0ee783a24480@mail.gmail.com>
References: <20090226133339.875832967@linutronix.de>
	<cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
	<alpine.LFD.2.00.0902262311350.9135@localhost.localdomain>
	<cfd18e0f0902271753ld9b432tae6c0ee783a24480@mail.gmail.com>
Emacs: more boundary conditions than the Middle East.
Message-Id: <20090228024424.D237CFC3DA@magilla.sf.frob.com>
Date: Fri, 27 Feb 2009 18:44:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With respect to the first point, it seems to me reasonably likely that
> there would be use cases where the receiving thread wants to know the
> thread ID of the sender -- especially when sender and receiver are in
> the same process.

But expecting si_pid to play that role is bizarre.  It's never what any
POSIX-like program would do, both since POSIX says si_pid is a process ID,
and because there are no POSIX-like interfaces at all that use Linux TIDs
to refer to threads.

Wanting this only seems plausible within one process.  In that case, sender
and recipient know they share memory.  The normal thing to do (and what
POSIX applications will do) is to store that info somewhere pointed to by
the sigval.


Thanks,
Roland
