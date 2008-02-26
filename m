Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbYBZHVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbYBZHVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYBZHUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:20:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48875 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbYBZHUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:20:53 -0500
Date: Tue, 26 Feb 2008 08:20:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: remove wrong setting about CONSTANT_TSC for
	intel cpu
Message-ID: <20080226072035.GB24820@elte.hu>
References: <200802252320.01534.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802252320.01534.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> also fix error in early_init_intel and reference about x86_capality, 
> because it is array already.., prevent possible data corruption...

hm, why should there be data corruption:

> -		set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
> +		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);

cpu_cpu_cap() is currently defined as:

 #define set_cpu_cap(c, bit)     set_bit(bit, (unsigned long *)((c)->x86_capability)

which is the same. set_cpu_cap() is indeed the cleaner form to do this 
so your patch is correct as a cleanup.

	Ingo
