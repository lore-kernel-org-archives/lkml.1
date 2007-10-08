Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbXJHPI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbXJHPI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXJHPIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:08:48 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60197 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbXJHPIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:08:47 -0400
Subject: Re: [PATCH 0/2] [RFC] RT: Optionally allow IRQF_NODELAY on serial
	console
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0710081037420.5290@gandalf.stny.rr.com>
References: <20071005153517.24349.62653.stgit@ghaskins-t60p.haskins.net>
	 <alpine.LRH.0.999.0710051831000.10191@www.tglx.de>
	 <Pine.LNX.4.58.0710081005320.4846@gandalf.stny.rr.com>
	 <1191853361.4281.5.camel@ghaskins-t60p.haskins.net>
	 <Pine.LNX.4.58.0710081037420.5290@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 08 Oct 2007 11:06:16 -0400
Message-Id: <1191855976.4281.13.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-08 at 10:41 -0400, Steven Rostedt wrote:
> --
> On Mon, 8 Oct 2007, Gregory Haskins wrote:
> >
> > Hi Steve,
> >   What you describe is exactly what I did.  The IRQF_NODELAY handler
> > just minimally checks to see if the character is a sysrq related one (or
> > KDB, if you have the KDB patches applied).  If it is not, it puts the
> > character into a ring-buffer and wakes a (kthread-based) tasklet to do
> > the normal serial/tty rx path by processing the ring.
> 
> Ah, that was in the second patch (I didn't look at that. My fault). I
> didn't see this description in the comments.

Well, the lack of a proper description is my fault.  I can fix this if
there is interest in actually including it.

>  But you are right, it is very
> close to what I did too. But before we add this to -rt, it will need to
> probably need to be tested quite a bit more.

Totally agree.  Note that it already is configurably inert, and defaults
to disabled so that might make it work for the general user just fine.
FWIW, our "debug" kernels have been running with the feature on for
quite a few weeks without problems.  But I would fully expect someone
external to want to quantify that claim on their own before it would be
considered.  So give it a whirl if you get a chance.

Regards,
-Greg

