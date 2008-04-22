Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbYDVOA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbYDVOA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbYDVOAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:00:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43904 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbYDVOAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:00:00 -0400
Date: Tue, 22 Apr 2008 15:59:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: cleanup early per cpu variables/accesses
	v3-folded
Message-ID: <20080422135944.GA24966@elte.hu>
References: <20080422013415.955439000@polaris-admin.engr.sgi.com> <20080422013416.483730000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422013416.483730000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mike Travis <travis@sgi.com> wrote:

>   * Introduce a new PER_CPU macro called "EARLY_PER_CPU".  This is
>     used by some per_cpu variables that are initialized and accessed
>     before there are per_cpu areas allocated.

build fails with:

arch/x86/kernel/built-in.o: In function `flat_apic_id_registered':
genapic_flat_64.c:(.text+0x13e1d): undefined reference to `phys_cpu_present_map'
genapic_flat_64.c:(.text+0x13e24): undefined reference to `phys_cpu_present_map'
arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
: undefined reference to `phys_cpu_present_map'
[...]

with this config:

  http://redhat.com/~mingo/misc/config-Tue_Apr_22_15_40_10_CEST_2008.bad

	Ingo
