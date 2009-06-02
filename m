Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbZFBAVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbZFBAVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZFBAU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:20:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbZFBAU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:20:58 -0400
Date: Tue, 2 Jun 2009 02:20:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rik van Riel <riel@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP
	convergence
Message-ID: <20090602002039.GA16410@elte.hu>
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org> <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org> <1243542817.29511.523.camel@jstultz-laptop> <20090601232223.GH749@elte.hu> <1243900716.11263.42.camel@jstultz-laptop> <4A246D0B.40204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A246D0B.40204@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> John Stultz wrote:
>> On Tue, 2009-06-02 at 01:22 +0200, Ingo Molnar wrote:
>
>>> I might be missing something here - but Linux converging faster  
>>> seems like a genuinely good thing. What non-Linux problem could  
>>> there be? Linux's convergence is really Linux's private issue. 
>>
>> Yea. It does seem that way. Miroslav can likely expand on the 
>> issue to help clarify, but as I understand it, the example is if 
>> you have a number of systems that are peers in an NTP network. 
>> All of them are using the same userland NTP daemon. However, if 
>> the rate of change that corrections are applied is different in 
>> half of them, you will have problems getting all the systems to 
>> converge together.
>
> Would this not be true already, because the convergence of Linux 
> system suddenly became a lot slower in 2.6.19?
>
> Damned if we do, damned if we don't - except the new behaviour 
> introduced by your patches is nicer.

Not just that - but there's calibration noise during bootup that can 
cause randomly distributed recalibrations as well. So other hosts in 
a mixed environment will see inconsistencies anyway, after every 
bootup.

NTP is all about being able to be resilient against time noise and 
being able to sync up to a common time base ASAP.

	Ingo
