Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXCMPPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXCMPPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXCMPPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:15:53 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3666 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXCMPPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:15:53 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 08:15:08 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEJDCDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070313081805.GA22327@elte.hu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 13 Mar 2007 07:15:28 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 13 Mar 2007 07:15:28 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> * Mike Galbraith <efault@gmx.de> wrote:
>
> > [...] The situation as we speak is that you can run cpu intensive
> > tasks while watching eye-candy.  With RSDL, you can't, you feel the
> > non-interactive load instantly. [...]
>
> i have to agree with Mike that this is a material regression that cannot
> be talked around.

I don't know what else you can do when the argument is that behavior that is
wrong is what you actually want. The regression is not that the scheduler
doesn't do what it was asked to do or even that it isn't more faithful to
what it was told to do than the scheduler it replaces. The regression is
that the scheduler didn't do what Mike wanted it to do, even though he
didn't ask it to do that.

I would argue this is progression, not regression. The new scheduler is
fairer than the old one and fairness is good even though it sometimes hurts
some tasks.

> Con, we want RSDL to /improve/ interactivity.

Not when the interactivity was the result of unfairness.

> Having new scheduler
> interactivity logic that behaves /worse/ in the presence of CPU hogs,
> which CPU hogs are even reniced to +5, than the current interactivity
> code, is i think a non-starter. Could you try to fix this, please?

If you did this, it would mean that all the space between the signficant
level of unfairness you want in this case and pure fairness would have to
fit in five nice levels. That just seems like poor granularity.

> Good
> interactivity in the presence of CPU hogs (be them default nice level or
> nice +5) is _the_ most important scheduler interactivity metric.
> Anything else is really secondary.

Good interactivity for tasks that aren't themselves CPU hogs. A task should
get low latency if and only if it's yielding the CPU voluntarily most of the
time. If it's not, it can only get better interactivity at the cost of
fairness, and you have to *ask* for that. (Common sense says you can't give
a task *more* CPU because it yields the CPU a lot. And how else do you
determine interactivity other than nice level?)

This scheduler will not give you greater interactivity at the cost of
fairness unless you really ask for it. I think that's a good thing, though I
do agree it might take some getting used to.

I'm not saying it is impossible to make RSDL better at handling this
particular job. I'm saying the "regression" may be the scheduler doing what
it was asked to do more faithfully than the current scheduler and the right
fix (at least in the longer term) is to ask for what you really want.

DS


