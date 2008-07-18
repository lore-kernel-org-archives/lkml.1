Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbYGRRAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbYGRRAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbYGRRA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:00:26 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:17810 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbYGRRAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:00:25 -0400
X-IronPort-AV: E=Sophos;i="4.31,211,1215388800"; 
   d="scan'208";a="1081280"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Large increase in context switch rate
Date: Fri, 18 Jul 2008 18:00:22 +0100
Message-ID: <0E902970173AF84089673FA54B7FE78A32906F@lonpexch01.citrite.net>
In-Reply-To: <87mykgrxtv.fsf@basil.nowhere.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Large increase in context switch rate
Thread-Index: AcjoVk2UzhJQbSOATO+0B6xgaZORqQAn/czA
References: <487E43D9.7080703@goop.org> <1216286250.5232.67.camel@twins><487F5F15.4050208@goop.org><0E902970173AF84089673FA54B7FE78A32906B@lonpexch01.citrite.net><487F6913.2000602@goop.org><0E902970173AF84089673FA54B7FE78A32906C@lonpexch01.citrite.net><487F6F1F.2030808@goop.org> <87mykgrxtv.fsf@basil.nowhere.org>
From: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ian Campbell" <Ian.Campbell@eu.citrix.com>
X-OriginalArrivalTime: 18 Jul 2008 17:00:23.0538 (UTC) FILETIME=[C4BD8520:01C8E8F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: 17 July 2008 22:43
> To: Jeremy Fitzhardinge
> Cc: Alex Nixon (Intern); Peter Zijlstra; Ingo Molnar; Linux Kernel
Mailing
> List; Ian Campbell
> Subject: Re: Large increase in context switch rate
> 
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> >
> > OK, but that still doesn't account for the relatively large increase
> > from 2.6.18 -> 2.6.26.  You're using HZ=100 in both cases, I
presume.
> >
> > The other variable is NOHZ and highres timers.  You could try
turning
> > those off in 2.6.26.  Also, CONFIG_PREEMPT could well make a
> > difference.  2.6.18-xen doesn't support CONFIG_PREEMPT at all, but
> > pvops(-xen) does.
> 
> If it's that easily reproducible you could just bisect it?
> 
> -Andi

I've bisected the majority of the increase down to some time between
2.6.18 and 2.6.19 - kernbench results are:

Kernel version    Elapsed    User    System    Context Switches
V2.6.18             232      427       28          32713
V2.6.19	        232      429       28          52812

NOHZ and highres timers are disabled wherever available, HZ=100, and
CONFIG_PREEMPT_VOLUNTARY=y

Will continue further on Monday.

- Alex
