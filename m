Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbYHNIlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbYHNIlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYHNIlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:41:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbYHNIln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:41:43 -0400
Date: Thu, 14 Aug 2008 10:41:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: crane cai <crane.cai@amd.com>
Cc: vojtech@suse.cz, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       XiaoGang Zheng <gang.zheng@amd.com>
Subject: Re: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700
	platform
Message-ID: <20080814084129.GA1650@elte.hu>
References: <1218683616.20466.13.camel@crane-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218683616.20466.13.camel@crane-laptop>
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


* crane cai <crane.cai@amd.com> wrote:

> >From 9bd2f534f986768f1944e626e37af1c323e47dbb Mon Sep 17 00:00:00 2001
> From: Crane Cai <crane.cai@amd.com>
> Date: Thu, 14 Aug 2008 10:31:01 +0800
> Subject: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700 platform
> 
> On the AMD SB700 southbridge, between the revisions 0x30 to 0x3a, when 
> its spread-spectrum frequency modulation feature is enabled, the base 
> frequency used by the HPET will not be running on average slower than 
> nominal 14.318 MHz.
>
> Since there is no provision in the OS for HPET to work with properly 
> with slower frequency, the BIOS on this platform uses SMM to emulate 
> accesses to the HPET config register to supply a corrected base 
> frequency to compensate for it.
>
> However, due to the implementation of the SMM BIOS code, there is a 
> time window after the first access to the HPET, which triggers 
> initialization of the SMM code, in which the HPET isn't available. 
> Thus it's necessary to wait until the HPET emulation is ready, and 
> this is what the patch does on the affected machines.

nice fix! I've applied it to tip/x86/urgent as the quirk is limited to 
this platform so it should be safe for v2.6.27 as well.

Exactly what kind of failure mode have you seen without the quirk? Do we 
read out the wrong values and thus hpet_clocksource_register() is 
calibrated incorrectly and you can get non-functional high-res timers? 
Have you seen hangs/crashes due to that, or incorrect timings?

> Signed-off-by: XiaoGang Zheng <gang.zheng@amd.com>
> Signed-off-by: Crane Cai <crane.cai@amd.com>

A quick question: the signoff order indicates that the patch has been 
authored by XiaoGang Zheng. Or is the reverse order intended? (you wrote 
the patch and XiaoGang Zheng processed it further)

	Ingo
