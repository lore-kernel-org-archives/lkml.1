Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbYGXB1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbYGXB1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 21:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbYGXB06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 21:26:58 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:46336 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750836AbYGXB05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 21:26:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PVljGMN0psAKTcUXArSxZjPLSgD+WjgqnTJVUVtHUQqJ2TIOOlk8VeivPmQdleMxJtEN9VAYgLNdG2ZnFbfbkmyZz1n2F+fezqzEjlqSCsN+zZ6TrUGRazYRTC8bblxcdbGDyq4r5+mTsKeZkM+U2TKg3wCzznrvkHoVdp1irIc=  ;
X-YMail-OSG: DPg4L0YVM1lG7E7_74Yb.AQZLHprQ5DPWcvQPIk6fCMj3uYnh55WnwipDAvpiEl_3MVlZnAj_adxTs_WxcAiM3E.V0omvGmjfDjMgWmSJVMDqPAUx.W16TLvFtK.hBeNsss-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>
Subject: Re: Large increase in context switch rate
Date: Thu, 24 Jul 2008 11:26:48 +1000
User-Agent: KMail/1.9.5
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ian Campbell" <Ian.Campbell@eu.citrix.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <487E43D9.7080703@goop.org> <87mykgrxtv.fsf@basil.nowhere.org> <0E902970173AF84089673FA54B7FE78A329073@lonpexch01.citrite.net>
In-Reply-To: <0E902970173AF84089673FA54B7FE78A329073@lonpexch01.citrite.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241126.48364.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2008 19:34, Alex Nixon (Intern) wrote:
> > -----Original Message-----
> > From: Andi Kleen [mailto:andi@firstfloor.org]
> > Sent: 17 July 2008 22:43
> > To: Jeremy Fitzhardinge
> > Cc: Alex Nixon (Intern); Peter Zijlstra; Ingo Molnar; Linux
> > Kernel Mailing List; Ian Campbell
> > Subject: Re: Large increase in context switch rate
> >
> > Jeremy Fitzhardinge <jeremy@goop.org> writes:
> > > OK, but that still doesn't account for the relatively large increase
> > > from 2.6.18 -> 2.6.26.  You're using HZ=100 in both cases,
> >
> > I presume.
> >
> > > The other variable is NOHZ and highres timers.  You could
> >
> > try turning
> >
> > > those off in 2.6.26.  Also, CONFIG_PREEMPT could well make a
> > > difference.  2.6.18-xen doesn't support CONFIG_PREEMPT at all, but
> > > pvops(-xen) does.
> >
> > If it's that easily reproducible you could just bisect it?
> >
> > -Andi
>
> I've bisected down to commit ba52de123d454b57369f291348266d86f4b35070 -
> [PATCH] inode-diet.  Before that kernbench consistently reports about
> 35k context switches (total), and after that commit about 53k.  The
> benchmarks are being run on a tmpfs.  I've verified the results on a
> different machine, albeit with an almost identical setup (the same
> kernels and debian distro, kernbench version, and benchmarking a build
> of the same source).
>
> Seems to be a mystery why that patch is (seemingly) the culprit...anyone
> have any ideas?  Maybe there's some other variable I'm not keeping
> constant?

Weird. It could possibly be triggering some different userspace behaviour
if blocksize reporting has changed anywhere. strace might help there.

Interesting if you could post the top results of profile=schedule for
a kernel with and without the patch.

