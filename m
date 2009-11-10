Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbZKJVeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbZKJVeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZKJVeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:34:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51542 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbZKJVeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:34:03 -0500
Date: Tue, 10 Nov 2009 22:33:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch v2] x86: reduce srat verbosity in the kernel log
Message-ID: <20091110213312.GE23196@elte.hu>
References: <87pr8ay6tc.fsf@basil.nowhere.org>
 <4AE710C9.2070307@sgi.com>
 <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com>
 <4AE75162.7080903@sgi.com>
 <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com>
 <20091028033219.GE7744@basil.fritz.box>
 <alpine.DEB.2.00.0910272041360.8988@chino.kir.corp.google.com>
 <20091028041159.GI7744@basil.fritz.box>
 <alpine.DEB.2.00.0910272129250.17260@chino.kir.corp.google.com>
 <alpine.DEB.2.00.0911101307440.28728@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911101307440.28728@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> On Tue, 27 Oct 2009, David Rientjes wrote:
> 
> > x86: reduce srat verbosity in the kernel log
> > 
> > It's possible to reduce the number of SRAT messages emitted to the kernel
> > log by printing each valid pxm once and then creating bitmaps to represent
> > the apic ids that map to the same node.
> > 
> > This reduces lines such as
> > 
> > 	SRAT: PXM 0 -> APIC 0 -> Node 0
> > 	SRAT: PXM 0 -> APIC 1 -> Node 0
> > 	SRAT: PXM 1 -> APIC 2 -> Node 1
> > 	SRAT: PXM 1 -> APIC 3 -> Node 1
> > 
> > to
> > 
> > 	SRAT: PXM 0 -> APIC {0-1} -> Node 0
> > 	SRAT: PXM 1 -> APIC {2-3} -> Node 1
> > 
> > The buffer used to store the apic id list is 128 characters in length.
> > If that is too small to represent all the apic id ranges that are bound
> > to a single pxm, a trailing "..." is added.  APICID_LIST_LEN should be
> > manually increased for such configurations.
> > 
> > Acked-by: Mike Travis <travis@sgi.com>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Ingo, have you had a chance to look at merging this yet?

I'm waiting for Mike to test them (and other patches) and send a new 
series out with bits to pick up.

But i really dont like such type of buffering - in the past they tended 
to be problematic. Why print this info at all in the default bootup?  
It's not needed on a correctly functioning system.

For failure analysis make it opt-in available via a boot parameter (if 
it's needed for bootup analysis) - but otherwise just dont print it.

	Ingo
