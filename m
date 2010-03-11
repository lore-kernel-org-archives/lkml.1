Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab0CKPqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:46:05 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:27253
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933121Ab0CKPqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:46:01 -0500
X-SpamScore: -1
X-BigFish: VPS-1(z3cfcs329epba6lz1432R98dN936eM62a3Lzz1202hzzz32i6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KZ4JSC-02-22M-02
X-M-MSG: 
Date: Thu, 11 Mar 2010 16:45:46 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/9] oprofile, perf, x86: introduce new functions to
 reserve perfctrs
Message-ID: <20100311154546.GD1585@erda.amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
 <1267725559.25158.208.camel@laptop>
 <1268308081.5037.14.camel@laptop>
 <20100311124716.GH31354@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100311124716.GH31354@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Mar 2010 15:45:47.0082 (UTC) FILETIME=[EAD44AA0:01CAC131]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.03.10 13:47:16, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> > Alternatively, could we maybe further simplify this reservation into:
> > 
> > int  reserve_pmu(void);
> > void release_pmu(void);
> > 
> > And not bother with anything finer grained.
> 
> Yeah, that looks quite a bit simpler.

It does not solve the current problem that some parts of the pmu *are*
used simultaneously by different subsystems. But, even if only perf
would be used in the kernel you still can't be sure that all parts of
the pmu are available to be used, you simply don't have it under your
control. So why such limitations as an 'int reserve_pmu(int index)' is
almost the same but provides much more flexibility?

The question already arose if the watchdog would use perf permanently
and thus would block oprofile by making it unusable. The current
reservation code would provide a framework to solves this, sharing
perfctrs with watchdog, perf and oprofile. And, since the pmu becomes
more and more features other than perfctrs, why shouldn't it be
possible to run one feature with perf and the other with oprofile?

> It's all about making it easier to live with legacies anyway - all modern 
> facilities will use perf events to access the PMU.

Scheduling events with perf is also 'some sort' of reservation, so
this code could be moved later into perf at all. In this case we also
will have to be able to reserve single counters or features by its
index.

For now, I don't think it is possible to change oprofile to use perf
in a big bang. This will disrupt oprofile users. I want to do the
switch to perf in a series of small changes and patch sets to make
sure, oprofile will not break. And this new reservation code is a step
towards perf.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

