Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbXFTNSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbXFTNSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbXFTNSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:18:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:55730 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754422AbXFTNSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:18:13 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18fJ8k8TiYfA+cfVYa1Gt1Oy7VNXr5dV275ZdvMb/
	GHLed3jmZ/6gEd
Date: Wed, 20 Jun 2007 15:18:29 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <ak@suse.de>
Cc: eranian@hpl.hp.com, oprofile-list@lists.sourceforge.net, wcohen@redhat.com,
       perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
       levon@movementarian.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 1/2] Separate the performance counter allocation from the LAPIC NMI watchdog
Message-ID: <20070620131829.GA17256@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Andi Kleen <ak@suse.de>, eranian@hpl.hp.com,
	oprofile-list@lists.sourceforge.net, wcohen@redhat.com,
	perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
	levon@movementarian.org, akpm@linux-foundation.org, mingo@elte.hu
References: <20070618103214.GA12045@atjola.homenet> <200706201431.44014.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706201431.44014.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.20 14:31:43 +0200, Andi Kleen wrote:
> On Wednesday 20 June 2007 12:35:56 Björn Steinbrink wrote:
> > The performance counter allocator is tied to the LAPIC NMI watchdog,
> 
> That's not true. It's completely independent. It just happens to be in
> the same file, but it has no direct functional ties to the watchdog.

The allocator relies on the wd_ops structure, which is only initialized
if the LAPIC NMI watchdog is enabled. If it is not enabled, the
functions that convert from absolute perfctr/evntsel addresses to
offsets from the respective base address break, and always return 0.

> > Fix the performance counter allocator by making it independent of the
> > LAPIC NMI watchdog. This also fixes a bug in the LAPIC NMI watchdog
> > which allocated the wrong performance counter on CPUs with PerfMon
> > support.
> 
> Combining code movement with functional fixes makes it impossible
> to review properly. Don't do that please.

Ok.

Björn
