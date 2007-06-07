Return-Path: <linux-kernel-owner+w=401wt.eu-S936419AbXFGASB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936419AbXFGASB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbXFGARv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:17:51 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:47942 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbXFGARu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:17:50 -0400
Message-ID: <46674EA9.9090601@de.ibm.com>
Date: Thu, 07 Jun 2007 02:17:45 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jbaron@redhat.com,
       rostedt@goodmis.org, linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
References: <1181165656.7133.23.camel@dix> <20070606230641.GA11592@elte.hu>
In-Reply-To: <20070606230641.GA11592@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Martin Peschke <mp3@de.ibm.com> wrote:
> 
>> The output has changed from a terribly wide table to an enormously 
>> long list (just the generic way the statistics code prints data). 
> 
> Sigh, why dont you _ask_ before doing such stuff?

A nice diffstat is always worth a try, isn't it?
And I see other reasons for code sharing.
Ah, and doing it has been actually quite simple once I had figured out
what the original code does. :-)

> It is a terribly wide table because that makes it easily greppable

If one looks for contentions of "xtime_lock" within my enormously long list,
they could issue:

    grep -e "xtime_lock contentions" data

and get

    xtime_lock contentions 0x17bd2 3327 account_ticks+0x96/0x184
    xtime_lock contentions other 0

for example.

So how is this worse?

> but still watchable in one chunk in a sufficiently zoomed out xterm.

I am wondering whether we really want to reject kernel patches on the basis of 
this reasoning, disregarding any other point why a patch might be helpful.

 > Please preserve this output format

I understand why everybody likes their format most. It's always made to measure.
Chosing a different - or common - format didn't happen in bad faith.

Made to measure file format doesn't work well once we start abstracting out this 
functionality. And I feel that was expected too much of a low level kernel ABI 
piece.

I would like to add that usuability doesn't necessarily suffer if statistics for 
some brand new gadget look somewhat familiar and similar to other statistics one 
  has encountered earlier.

>, quite some work went into it - NACK :-(

Considering the amount of code.. ;-)    I am sorry.

But seriously, did you consider using some user space tool or script to
format this stuff the way you like it - similar to the way the powertop tool
reshuffles timer_stats data found in a proc file, for example?

The format of an enormously long list has been thought out keeping this 
particular requirement in mind.


	Martin

