Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbXFKL0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbXFKL0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXFKL0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:26:22 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:44263 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbXFKL0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:26:20 -0400
Message-ID: <466D3148.2050607@de.ibm.com>
Date: Mon, 11 Jun 2007 13:26:00 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: "Bill Huey (hui)" <billh@gnuppy.monkey.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, jbaron@redhat.com, rostedt@goodmis.org,
       linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
References: <1181165656.7133.23.camel@dix> <20070606230641.GA11592@elte.hu> <46674EA9.9090601@de.ibm.com> <20070607044017.GA3828@gnuppy.monkey.org> <4667ADDA.2070202@de.ibm.com> <20070607073021.GA21139@elte.hu> <20070607085645.GA29054@gnuppy.monkey.org>
In-Reply-To: <20070607085645.GA29054@gnuppy.monkey.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Huey (hui) wrote:
 > However, I don't understand why all of this
 > is so heavy weight when the current measurements that Peter makes is
 > completely sufficient for any reasonable purpose I can think of at the
 > moment.

It wasn't meant to be or to stay heavy weight. To make the best of my
recent attempt: It's good that such issues show up.

 > What's this stuff with labels about ?

Sorry, I didn't come around to posting a documentation update.

It's an optional callback that allows a user to label an entry of
a statistic when it is printed. I have used this feature for adding
symbol strings to instruction pointers.

 > It's important to get the points of contention so that the greater
 > kernel group can fix this issues and not log statistics for the purpose
 > of logging it. The original purpose should not be ignore when working
 > on this stuff.

Sure.

 > By the way, what's the purpose of all of this stuff ? like what do you
 > intend to do with it over the long haul ?

Well, it started as statistics code of a device driver. When I realized
that I was increasing code duplication in the kernel, I tried to abstract
the code out that is device driver independent, allowing others to reuse it.
I have done a couple of iterations, adapting the code to requirements
which showed up when using the code for another driver etc.

This time, my lock contentaion patch showed two issues that require work:
struct statistics needs to be slimmed down or be eliminated alltogether;
allocations might be fine for some users but not for all. Solving
these issues is feasible. Anyway, I don't think I can effort pursueing
it further.

Martin

