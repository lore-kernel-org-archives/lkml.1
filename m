Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbYHVGTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbYHVGTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYHVGTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:19:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbYHVGTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:19:24 -0400
Date: Fri, 22 Aug 2008 08:19:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: silence section mismatch warning - uv_cpu_init
Message-ID: <20080822061901.GN14110@elte.hu>
References: <1219259268-5868-2-git-send-email-marcin.slusarz@gmail.com> <20080821103444.GE19452@elte.hu> <20080821184859.GA5403@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821184859.GA5403@joi>
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


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: [PATCH v2] x86: fix section mismatch warning - uv_cpu_init
> 
> WARNING: vmlinux.o(.cpuinit.text+0x3cc4): Section mismatch in reference from the function uv_cpu_init() to the function .init.text:uv_system_init()
> The function __cpuinit uv_cpu_init() references
> a function __init uv_system_init().
> If uv_system_init is only used by uv_cpu_init then
> annotate uv_system_init with a matching annotation.
> 
> uv_system_init was ment to be called only once, so do it from codepath
> (native_smp_prepare_cpus) which is called once, right before activation
> of other cpus (smp_init).
> 
> Note: old code relied on uv_node_to_blade being initialized to 0,
> but it'a not initialized from anywhere.

thanks - applied it to tip/x86/urgent. Jack, any objections?

	Ingo
