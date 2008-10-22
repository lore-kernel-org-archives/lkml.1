Return-Path: <linux-kernel-owner+w=401wt.eu-S1759112AbYJVT0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbYJVT0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbYJVT0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:26:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53734 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217AbYJVT0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:26:32 -0400
Date: Wed, 22 Oct 2008 21:26:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
	set.
Message-ID: <20081022192622.GA30930@elte.hu>
References: <1224552902.2640.88.camel@alok-dev1> <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1> <20081021174008.GH12825@one.firstfloor.org> <1224612294.6161.43.camel@alok-dev1> <20081021181536.GI12825@one.firstfloor.org> <1224616236.6161.60.camel@alok-dev1> <20081021192746.GJ12825@one.firstfloor.org> <1224703427.13953.8.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224703427.13953.8.camel@alok-dev1>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alok Kataria <akataria@vmware.com> wrote:

> Skip tsc synchronization checks if CONSTANT_TSC bit is set.
> 
> From: Alok N Kataria <akataria@vmware.com>
> 
> TSC synchronization checks between CPU's bail out even if we see a 
> distortion of a single cycle. This makes the TSC mostly unsuable in a 
> virtualized environment.
> 
> The CONSTANT_TSC bit tells us if the hardware exports a constant TSC, 
> we can use this bit to trust the hardware and skip the TSC sync checks 
> at bootup.

the sync check is there to check the _offset_ between CPUs. CONSTANT_TSC 
is not a guarantee that the TSC will be coherent across all CPUs.

so this patch is fundamentally wrong.

	Ingo
