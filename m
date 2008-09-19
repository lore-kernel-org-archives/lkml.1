Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYISRVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYISRVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYISRVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:21:00 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:18072 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYISRU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:20:59 -0400
X-BigFish: VPS-29(zz1432R98dR1805M936fQ3117K873fnzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7GDIG-01-M3R-01
Date: Fri, 19 Sep 2008 19:20:19 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Valdis.Kletnieks@vt.edu
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: c1e_idle: don't mark TSC unstable if CPU has
	invariant TSC
Message-ID: <20080919172019.GA16896@alberich.amd.com>
References: <20080918191210.GD23287@alberich.amd.com> <27087.1221766532@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <27087.1221766532@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 19 Sep 2008 17:20:47.0542 (UTC) FILETIME=[0E53F560:01C91A7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 03:35:32PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 18 Sep 2008 21:12:10 +0200, Andreas Herrmann said:
> > .. otherwise TSC is marked unstable on AMD family 0x10 and 0x11 CPUs.
> 
> OK.  I'll bite (admittedly not having looked at the actual code yet).
> 
> If the TSC is in fact invariant, what's causing the kernel to mark it as
> unstable?

Guess, you should have a look at the code.

TSC on K8 is not P-state and C-state invariant.
Thus on K8 you'll have a TSC drift if C1E is entered.

This means that if C1E is enabled TSC should be marked unstable on
those CPUs (it shouldn't be used as a clocksource).

> Sounds almost like a bug being papered over here...

Not sure what you mean.

Currently the kernel assumes TSC is stable and there are various
places where Linux might spot when TSC is unstable. c1e_idle is one
such place. But it's wrong to mark TSC unstable for all AMD CPUs in
this function as newer CPU families have TSC's that are P- and C-state
invariant.


Regards,

Andreas


