Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYGWJez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYGWJez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYGWJep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:34:45 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:36019 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYGWJeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:34:44 -0400
X-IronPort-AV: E=Sophos;i="4.31,237,1215388800"; 
   d="scan'208";a="1128787"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Large increase in context switch rate
Date: Wed, 23 Jul 2008 10:34:10 +0100
Message-ID: <0E902970173AF84089673FA54B7FE78A329073@lonpexch01.citrite.net>
In-Reply-To: <87mykgrxtv.fsf@basil.nowhere.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Large increase in context switch rate
Thread-Index: AcjoVk2UzhJQbSOATO+0B6xgaZORqQETv0KA
References: <487E43D9.7080703@goop.org> <1216286250.5232.67.camel@twins><487F5F15.4050208@goop.org><0E902970173AF84089673FA54B7FE78A32906B@lonpexch01.citrite.net><487F6913.2000602@goop.org><0E902970173AF84089673FA54B7FE78A32906C@lonpexch01.citrite.net><487F6F1F.2030808@goop.org> <87mykgrxtv.fsf@basil.nowhere.org>
From: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ian Campbell" <Ian.Campbell@eu.citrix.com>,
       "Theodore Ts'o" <tytso@mit.edu>
X-OriginalArrivalTime: 23 Jul 2008 09:34:11.0123 (UTC) FILETIME=[4333F030:01C8ECA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org] 
> Sent: 17 July 2008 22:43
> To: Jeremy Fitzhardinge
> Cc: Alex Nixon (Intern); Peter Zijlstra; Ingo Molnar; Linux 
> Kernel Mailing List; Ian Campbell
> Subject: Re: Large increase in context switch rate
> 
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> >
> > OK, but that still doesn't account for the relatively large increase
> > from 2.6.18 -> 2.6.26.  You're using HZ=100 in both cases, 
> I presume.
> >
> > The other variable is NOHZ and highres timers.  You could 
> try turning
> > those off in 2.6.26.  Also, CONFIG_PREEMPT could well make a
> > difference.  2.6.18-xen doesn't support CONFIG_PREEMPT at all, but
> > pvops(-xen) does.
> 
> If it's that easily reproducible you could just bisect it?
> 
> -Andi
> 

I've bisected down to commit ba52de123d454b57369f291348266d86f4b35070 -
[PATCH] inode-diet.  Before that kernbench consistently reports about
35k context switches (total), and after that commit about 53k.  The
benchmarks are being run on a tmpfs.  I've verified the results on a
different machine, albeit with an almost identical setup (the same
kernels and debian distro, kernbench version, and benchmarking a build
of the same source).

Seems to be a mystery why that patch is (seemingly) the culprit...anyone
have any ideas?  Maybe there's some other variable I'm not keeping
constant?

- Alex
