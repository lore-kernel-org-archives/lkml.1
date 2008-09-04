Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYIDPgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYIDPgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYIDPgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:36:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40701 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYIDPgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:36:38 -0400
Date: Thu, 4 Sep 2008 17:36:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080904153620.GC7120@elte.hu>
References: <20080904150339.896115280@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904150339.896115280@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> This patch series addresses following:
> 
>      - reduce the calibration time to a useful value
>      - make decision smarter, when a reference (HPET/PMTIMER) is around
> 
> The first patches are cleanups to prepare for the smarter loop
> handling.
> 
> The main change is to reduce the PIT delay value to 10ms, which gives
> reasonable results on very slow machines as well. To avoid looping
> several times when the machine has a working reference counter
> (HPET/pmtimer), we compare the results of the PIT and the reference and
> break out of the loop when both match inside of a 10% window.
> 
> For virtualized environments the PIT calibration fails often and the
> reference calibration is not reproducible with 10ms. To address this
> we check whether the PIT failed two times in a row and make the PIT
> loop longer (50ms) for the last try to get a better result for the
> reference.
> 
> Most of the machines I tested break out of the loop after the first
> try with a stable reproducible result.

i've added them to tip/x86/tsc and merged it into tip/master - if 
there's test success we can merge it into x86/urgent as well and push it 
into v2.6.27. Any objections to that merge route?

	Ingo
