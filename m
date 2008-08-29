Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbYH2Qeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbYH2Qeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYH2Qe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:34:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61103 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbYH2Qe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:34:27 -0400
Date: Fri, 29 Aug 2008 12:34:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, Gregory Haskins <ghaskins@novell.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] seqlock: serialize against writers
In-Reply-To: <48B82349.1020109@gmail.com>
Message-ID: <alpine.DEB.1.10.0808291233280.17917@gandalf.stny.rr.com>
References: <20080829154237.1196.66825.stgit@dev.haskins.net> <87abevpzv7.fsf@basil.nowhere.org> <48B81F60.3080409@gmail.com> <20080829162216.GW26610@one.firstfloor.org> <48B82349.1020109@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Gregory Haskins wrote:

> Andi Kleen wrote:
> >> Im running it on a x86_64 box as we speak.  How can I tell if there is a
> >> certain mode that is permitting this?
> >>     
> >
> > If the boot up says you're running with PMtimer then it uses the fallback
> > (usually happens on pre Fam10h AMD boxes). A typical Intel box
> > would use the faster ring 3 only TSC path and then explode with your
> > change I bet. 
> >
> > Or step with gdb through gettimeofday() and see if it does a syscall.
> >
> > -Andi
> >   
> 
> It seems to be running fine with no indication it has fallen back. 
> Perhaps I need a certain workload to bring out the issue?

Perhaps you never hit the slow path in userland. That's the only place it 
would write. Perhaps add a dummy static variable in the fast path, and 
write to it. See if that crashes you apps.

-- Steve
