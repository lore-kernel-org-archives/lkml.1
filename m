Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbYGQQLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbYGQQLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYGQQLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:11:24 -0400
Received: from gw.goop.org ([64.81.55.164]:54127 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbYGQQLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:11:24 -0400
Message-ID: <487F6F1F.2030808@goop.org>
Date: Thu, 17 Jul 2008 09:11:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: Large increase in context switch rate
References: <487E43D9.7080703@goop.org> <1216286250.5232.67.camel@twins> <487F5F15.4050208@goop.org> <0E902970173AF84089673FA54B7FE78A32906B@lonpexch01.citrite.net> <487F6913.2000602@goop.org> <0E902970173AF84089673FA54B7FE78A32906C@lonpexch01.citrite.net>
In-Reply-To: <0E902970173AF84089673FA54B7FE78A32906C@lonpexch01.citrite.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Don't top-post.)

Alex Nixon (Intern) wrote:
> I'm talking about total number of context switches - kernbench gets it
> from
>
> time -f "%c" make -j 4
>
> Dividing through it gives me a rate of around 250/sec (vs Peters 3000),
> but I've set CONFIG_HZ=100 (vs Peters 1000), so they don't wildly
> conflict.
>
> Well spotted :-)
>   

OK, but that still doesn't account for the relatively large increase 
from 2.6.18 -> 2.6.26.  You're using HZ=100 in both cases, I presume.

The other variable is NOHZ and highres timers.  You could try turning 
those off in 2.6.26.  Also, CONFIG_PREEMPT could well make a 
difference.  2.6.18-xen doesn't support CONFIG_PREEMPT at all, but 
pvops(-xen) does.

    J
