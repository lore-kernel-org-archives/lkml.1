Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYKRVOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYKRVOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYKRVOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:14:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41471 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYKRVOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:14:38 -0500
Date: Tue, 18 Nov 2008 22:14:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2 - fix v2
Message-ID: <20081118211413.GE11490@elte.hu>
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117173728.GA7384@elte.hu> <4921FC19.1080803@kernel.org> <20081117232837.GA10308@elte.hu> <20081118074346.GA21875@elte.hu> <4922E99B.8090604@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4922E99B.8090604@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix wakeup_secondary_cpu with hotplug
> 
> We can not put that in x86_quirks, because that is __initdata.
> So try to move that to genapic, and add update_genapic in x86_quirks.
> 
> later we even could use that stub to
> 1. autodetect CONFIG_ES7000_CLUSTERED_APIC
> 2. more correct inquire_remote_apic with apic_verbosity setting.

thanks - this patch and the next one did the trick to stabilize the 
tip/x86/quirks topic tree - no more hotplug crashes and no more build 
failures either. The lineup is:

 b5fe363: x86: use update_genapic to get rid of ES7000_CLUSTERED_APIC v2
 f632ddc: x86: fix wakeup_cpu with numaq/es7000, v2, fix #2
 54ac14a: x86: fix wakeup_cpu with numaq/es7000, v2, fix
 569712b: x86: fix wakeup_cpu with numaq/es7000, v2

and i've merged them into tip/master as well.

	Ingo
