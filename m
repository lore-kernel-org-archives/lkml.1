Return-Path: <linux-kernel-owner+w=401wt.eu-S965503AbXIJQQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965503AbXIJQQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbXIJQPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:15:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:50015 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281AbXIJQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:15:53 -0400
Date: Mon, 10 Sep 2007 09:13:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 3/4] modify account_system_time() to update
 guest time in cpustat and task_struct
Message-Id: <20070910091321.f0c63c34.randy.dunlap@oracle.com>
In-Reply-To: <46E56A5E.20209@bull.net>
References: <46E550EA.1030809@bull.net>
	<20070910085331.84dc1fb5.randy.dunlap@oracle.com>
	<46E56A5E.20209@bull.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 18:01:34 +0200 Laurent Vivier wrote:

> Randy Dunlap wrote:
> > On Mon, 10 Sep 2007 16:12:58 +0200 Laurent Vivier wrote:
> > 
> >> [PATCH 3/4] modify account_system_time() to add cputime to cpustat->guest if we
> >> are running a VCPU. We add this cputime to  cpustat->user instead of
> >> cpustat->system because this part of KVM code is in fact user code although it
> >> is executed in the kernel. We duplicate VCPU time between guest and user to
> >> allow an unmodified "top(1)" to display correct value. A modified "top(1)" is
> >> able to display good cpu user time and cpu guest time by subtracting cpu guest
> >> time from cpu user time. Update "gtime" in task_struct accordingly.
> >>
> >> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
> > 
> > 
> > Hi,
> > Please use kernel-doc notation here:
> > (see Documentation/kernel-doc-nano-HOWTO.txt or source file examples
> > or ask)
> > 
> > easy fix:
> > 
> >  /*
> > + * Account guest cpu time to a process.
> > 
> > /**
> >  * account_guest_time - Account guest cpu time to a process.
> > 
> > + * @p: the process that the cpu time gets accounted to
> > + * @cputime: the cpu time spent in virtual machine since the last update
> > + */
> > +void account_guest_time(struct task_struct *p, cputime_t cputime)
> > +{
> 
> thank you for the comment.
> 
> But I just made a cut&past of the comment of the function above.
> 
> Should I be consistent with the doc or with the source ?

I see.  That entire file could use some kernel-doc-ization.

I suppose that lessens the need for you to make such a change.
I'll probably do it some slow night then.

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
