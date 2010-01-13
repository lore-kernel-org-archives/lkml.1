Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152Ab0AMTxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab0AMTxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625Ab0AMTxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:53:32 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:43420 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290Ab0AMTxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:53:32 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Nicholas Miell <nmiell@comcast.net>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <4B4E2208.4030307@caviumnetworks.com>
References: <20100113013757.GA29314@Krystal>
	 <1263358823.3874.10.camel@entropy>
	 <20100113053126.GC6781@linux.vnet.ibm.com>
	 <1263361196.3874.12.camel@entropy> <20100113143805.GC30875@Krystal>
	 <1263406071.3874.16.camel@entropy> <20100113182442.GA20704@Krystal>
	 <1263408098.3874.19.camel@entropy> <20100113191727.GA24742@Krystal>
	 <4B4E2208.4030307@caviumnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 11:53:27 -0800
Message-ID: <1263412407.3874.21.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 11:42 -0800, David Daney wrote:
> Mathieu Desnoyers wrote:
> > * Nicholas Miell (nmiell@comcast.net) wrote:
> >> On Wed, 2010-01-13 at 13:24 -0500, Mathieu Desnoyers wrote:
> >>> * Nicholas Miell (nmiell@comcast.net) wrote:
> >>>
> >>>> The whole point of compat and incompat flags is that it allows new
> >>>> applications to run on old kernels and either work or fail as
> >>>> appropriate, depending on whether the new features they're using must be
> >>>> implemented or can be silently ignored.
> >>> I see. Thanks for the explanation. Then the expedited flag should
> >>> clearly be part of the mandatory flags.
> >>>
> >>> Can you point me to other system calls that are doing this ?
> >>>
> >>> Thanks,
> >>>
> >>> Mathieu
> >> Not off the top of my head, but I did steal the idea from the ext2/3/4
> >> disk format.
> > 
> > Sounds a bit over-engineered to me for system calls, but who knows if we
> > eventually have to extend sys_membarrier(). This involves that, right
> > now, I'd have to add a header to include/linux to define these flags.
> > Also, "int expedited" is a bit clearer, but less flexible, than "int
> > flags". Anyone else have comments about this ?
> > 
> 
> It doesn't bother me that you have to do extra work to add the flag 
> definitions to a header file. :-)
> 
> As I understand it, the proposal is to have the option to extend the ABI 
> based on as yet undefined flag bits.  This doesn't seem like a bad thing.
> 
> The runtime overhead of testing a single bit vs. non-zero in the 
> parameter shouldn't be an issue.
> 

The recent introduction of accept4(), signalfd4(), eventfd2(),
epoll_create1(), dup3(), pipe2(), and inotify_init1() suggest that this
is the kind of thing you want to plan for, because you're probably going
to end up doing it anyway.

-- 
Nicholas Miell <nmiell@comcast.net>

