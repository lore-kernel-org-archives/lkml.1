Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZFAXWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZFAXWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZFAXWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:22:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56112 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbZFAXWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:22:38 -0400
Date: Tue, 2 Jun 2009 01:22:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <johnstul@us.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP
	convergence
Message-ID: <20090601232223.GH749@elte.hu>
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org> <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org> <1243542817.29511.523.camel@jstultz-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243542817.29511.523.camel@jstultz-laptop>
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


* John Stultz <johnstul@us.ibm.com> wrote:

> On Wed, 2009-05-06 at 09:46 +0000, tip-bot for john stultz wrote:
> > Commit-ID:  22cfbbfd9f67b67fe073010f51cb71d3632387d5
> > Gitweb:     http://git.kernel.org/tip/22cfbbfd9f67b67fe073010f51cb71d3632387d5
> > Author:     john stultz <johnstul@us.ibm.com>
> > AuthorDate: Wed, 6 May 2009 11:43:57 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 6 May 2009 11:44:02 +0200
> > 
> > ntp: adjust SHIFT_PLL to improve NTP convergence
> > 
> > The conversion to the ntpv4 reference model
> > f19923937321244e7dc334767eb4b67e0e3d5c74 ("ntp: convert to the NTP4
> > reference model") in 2.6.19 added nanosecond resolution the adjtimex
> > interface, but also changed the "stiffness" of the frequency adjustments,
> > causing NTP convergence time to greatly increase.
> > 
> > SHIFT_PLL, which reduces the stiffness of the freq adjustments, was
> > designed to be inversely linked to HZ, and the reference value of 4 was
> > designed for Unix systems using HZ=100.  However Linux's clock steering
> > code mostly independent of HZ.
> > 
> > So this patch reduces the SHIFT_PLL value from 4 to 2, which causes NTPd
> > behavior to match kernels prior to 2.6.19, greatly reducing convergence
> > times, and improving close synchronization through environmental thermal
> > changes.
> > 
> > The patch also changes some l's to L's in nearby code to avoid misreading
> > 50l as 501.
> > 
> > [ Impact: tweak NTP algorithm for faster convergence ]
> 
> Hey Ingo,
>
> 	So I've been speaking with Miroslav (cc'ed) who maintains 
> the RH ntpd packages, and he's concerned that this patch takes us 
> out of NTP's expected behavior, which may cause problems when 
> dealing with non-linux systems using NTP.

I might be missing something here - but Linux converging faster 
seems like a genuinely good thing. What non-Linux problem could 
there be? Linux's convergence is really Linux's private issue. 

(since things like the PIT calibration are random noise for which 
there can be no external expecation about our convergence speed 
anyway.)

	Ingo
