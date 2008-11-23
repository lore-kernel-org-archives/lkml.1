Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYKWN2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYKWN2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 08:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbYKWN2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 08:28:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50788 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbYKWN2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 08:28:02 -0500
Date: Sun, 23 Nov 2008 14:27:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: KPROBE_ENTRY should be paired wth KPROBE_END
Message-ID: <20081123132752.GF1178@elte.hu>
References: <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123091532.GA31515@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123091532.GA31515@mailshack.com>
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> Impact: moves some code out of .kprobes.text
> 
> KPROBE_ENTRY switches code generation to .kprobes.text, and KPROBE_END
> uses .popsection to get back to the previous section (.text, normally).
> Also replace ENDPROC by END, for consistency.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

applied to tip/x86/irq, thanks Alexander!

> One more small change for today. The xen-related functions 
> xen_do_hypervisor_callback and xen_failsafe_callback are put
> in the .kprobes.text even in the current kernel: ignore_sysret
> is enclosed in KPROBE_ENTRY / ENDPROC, instead of KPROBE_ENTRY /
> KPROBE_END, but I guess the situation is harmless.

yeah. It narrows no-kprobes protection for that code, but it should 
indeed be fine (and that's the intention as well).

Note that this is a reoccuring bug type, and rather long-lived. Can 
you think of any way to get automated nesting protection of both the 
.cfi_startproc/endproc macros and kprobes start/end? A poor man's 
solution would be to grep the number of start and end methods and 
enforce that they are equal.

	Ingo
