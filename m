Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYDHLox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYDHLox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYDHLop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:44:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33449 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYDHLop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:44:45 -0400
Date: Tue, 8 Apr 2008 13:49:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nuno Fernandes <npf-mlists@eurotux.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: proc_stack for x86_64 (spinning process)
Message-ID: <20080408114908.GO16647@one.firstfloor.org>
References: <200804081136.41876.npf@eurotux.com> <87myo4pp66.fsf@basil.nowhere.org> <200804081241.45776.npf-mlists@eurotux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804081241.45776.npf-mlists@eurotux.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 12:41:45PM +0100, Nuno Fernandes wrote:
> On Tuesday 08 April 2008 12:21:53 Andi Kleen wrote:
> > Nuno Pais Fernandes <npf@eurotux.com> writes:
> > > Hi,
> > >
> > > I have a spinning process that it's locking my server (eating 100% CPU).
> > > I can't kill it even with kill -9
> > >
> > > I'm trying to use proc_stack to check what's the problem, compiling the
> > > kernel with
> > >
> > > http://linuxhacker.ru/~nikita/patches/2.6.12-rc6/2005.06.11/vm_07-proc-st
> > >ack.patch
> > >
> > > But this patch is only for x86 as my arch is x86_64. Does anyone know if
> > > there's a patch for x86_64?
> >
> > The standard way to handle that is to just do
> >
> > echo 1 > /proc/sys/kernel/sysrq
> > echo t > /proc/sysrq-trigger
> >
> > and then look for the process backtrace in the kernel log.
> I've already done that but the problem is that the "R" script does not show 
> any backtrack. Apparently it's spinning inside kernel and all other processes 
> become in D state (uninterrutable sleep) because of that one.

Then you can either try to catch it with sysrq-p (but only works rarely)
or better use the crash method. But if the process is running live dump
might not work, you might need to force a non live dump using sysrq-c

Another way to identify spinning code is to use a profiler like oprofile
or readprofile.  Something that spins tends to be on top.

-Andi

