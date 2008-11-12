Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYKLWa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYKLWa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYKLWaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:30:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40828 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbYKLWaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:30:14 -0500
Date: Wed, 12 Nov 2008 23:29:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86: Hibernate: Fix breakage on x86_32 with
	CONFIG_NUMA set (was: Re: CONFIG_NUMA breaks hibernation on x86-32
	with PAE)
Message-ID: <20081112222927.GA13844@elte.hu>
References: <20081109140726.GB1786@ucw.cz> <20081112104951.GB11945@ucw.cz> <200811122257.50998.rjw@sisk.pl> <200811122322.36781.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811122322.36781.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: x86: Hibernate: Fix breakage on x86_32 with CONFIG_NUMA set
> 
> The NUMA code on x86_32 creates special memory mapping that allows
> each node's pgdat to be located in this node's memory.  For this
> purpose it allocates a memory area at the end of each node's memory
> and maps this area so that it is accessible with virtual addresses
> belonging to low memory.  As a result, if there is high memory,
> these NUMA-allocated areas are physically located in high memory,
> although they are mapped to low memory addresses.
> 
> Our hibernation code does not take that into account and for this
> reason hibernation fails on all x86_32 systems with CONFIG_NUMA=y and
> with high memory present.  Fix this by adding a special mapping for
> the NUMA-allocated memory areas to the temporary page tables created
> during the last phase of resume.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Pavel Machek <pavel@suse.cz>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/include/asm/mmzone_32.h |    4 ++++
>  arch/x86/mm/numa_32.c            |   35 +++++++++++++++++++++++++++++++++++
>  arch/x86/power/hibernate_32.c    |    4 ++++
>  3 files changed, 43 insertions(+)

Applied to tip/x86/numa, thanks Rafael for the detective work!

	Ingo
