Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbXCPSgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbXCPSgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbXCPSgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:36:21 -0400
Received: from mx1.suse.de ([195.135.220.2]:45446 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbXCPSgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:36:20 -0400
Message-ID: <5920992.1174070178992.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
Date: Fri, 16 Mar 2007 19:36:18 +0100 (CET)
From: Andreas Kleen <ak@suse.de>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] Add an offset in the cyc2ns computation to fix	sched_clock jumps
Cc: Guillaume Chazarain <guichaz@gmail.com>, john stultz <johnstul@us.ibm.com>,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
In-Reply-To: <1174069846.3101.113.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3 (normal)
X-Mailer: SuSE Linux Openexchange Server 4 - WebMail (Build 2.4160)
X-Operating-System: Linux 2.4.21-314-smp i386 (JVM 1.3.1_19)
Organization: SuSE Linux AG
References: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com> <1174069846.3101.113.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fr 16.03.2007 19:30 schrieb Daniel Walker <dwalker@mvista.com>:

> On Fri, 2007-03-16 at 19:14 +0100, Guillaume Chazarain wrote:
> > Hello,
> >
> > The scheduling problems I reported in the thread:
> > http://lkml.org/lkml/2007/3/3/128
> > are caused by the set_cyc2ns_scale() function called when the CPU
> > speed changes.
> > Changing the scale causes a warp in the value returned by
> > sched_clock().
> >
>
> Did you explain what the "werirdnes" was exactly? If not, could you?

I fixed this in my own version of the change by marking it unstable
during the transition
(concept stolen from Jiri's patch). Basically watch the notifiers for
before/after
and while the transition is in progress always ask for that underlying
monotonic ktime.

-Andi


