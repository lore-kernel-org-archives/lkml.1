Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZGCIGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZGCIGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZGCIGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:06:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbZGCIGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:06:19 -0400
Date: Fri, 3 Jul 2009 10:05:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, alex.shi@intel.com,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] x86: add boundary check for 32bit res before expand
	e820 resource to alignment -v2
Message-ID: <20090703080547.GC13505@elte.hu>
References: <4A4A81C9.9070008@zytor.com> <4A4A88A2.7010509@kernel.org> <alpine.LFD.2.01.0906301456170.3605@localhost.localdomain> <4A4A921F.7080100@kernel.org> <alpine.LFD.2.01.0906301559390.3605@localhost.localdomain> <alpine.LFD.2.01.0906301603280.3605@localhost.localdomain> <4A4A9C2F.80808@kernel.org> <4A4A9D8E.5080500@zytor.com> <4A4BB9C2.8020304@kernel.org> <4A4CF830.6000206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4CF830.6000206@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> +#define MAX_RESOURCE_SIZE ((resource_size_t)-1)

> +		end = round_up(start, ram_alignment(start)) - 1;
> +		if (end > MAX_RESOURCE_SIZE)
> +			end = MAX_RESOURCE_SIZE;

As Andrew noted it, this should probably have a comment along the 
lines of:

		/*
		 * Clip entries that go beyond our maximum resource 
		 * awareness limit to the max. If we accepted them
		 * blindly we'd get random rounding artifacts and a 
		 * possibly messed up resource tree and boot 
		 * failures:
		 */
		if (end > MAX_RESOURCE_SIZE)
			end = MAX_RESOURCE_SIZE;

	Ingo
