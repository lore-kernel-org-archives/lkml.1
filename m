Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYJ3Xpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYJ3Xpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYJ3Xpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:45:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbYJ3Xpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:45:42 -0400
Date: Fri, 31 Oct 2008 00:45:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix missing cpu_index initialisation
Message-ID: <20081030234529.GA19298@elte.hu>
References: <1225401217.19324.28.camel@localhost.localdomain> <20081030231723.GB1985@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030231723.GB1985@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Depends on [VOYAGER] x86: add ability to test for boot CPU
> 
> applied both to tip/x86/urgent:
> 
>  6b5496e: x86/voyager: fix missing cpu_index initialisation
>  3b25aec: x86/voyager: fix compile breakage caused by dc1e35c6e95e8923cf1d35104

this broke the x86 build:

 arch/x86/kernel/cpu/common.c: In function 'early_identify_cpu':
 arch/x86/kernel/cpu/common.c:553: error: 'struct cpuinfo_x86' has no member named 'cpu_index'

fixed via the patch below.

	Ingo

---------->
>From 1c4acdb467f8a6704855a5670ff3d82e3c18eb0b Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 31 Oct 2008 00:43:03 +0100
Subject: [PATCH] x86: cpu_index build fix

fix:

 arch/x86/kernel/cpu/common.c: In function 'early_identify_cpu':
 arch/x86/kernel/cpu/common.c:553: error: 'struct cpuinfo_x86' has no member named 'cpu_index'

as cpu_index is only available on SMP.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index da8f15a..003a653 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -550,7 +550,9 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 	validate_pat_support(c);
 
+#ifdef CONFIG_SMP
 	c->cpu_index = boot_cpu_id;
+#endif
 }
 
 void __init early_cpu_init(void)
