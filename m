Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbYKQRfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbYKQRfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYKQRfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:35:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46903 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbYKQRfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:35:41 -0500
Date: Mon, 17 Nov 2008 18:35:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
Message-ID: <20081117173527.GA2827@elte.hu>
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117171157.GB7326@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117171157.GB7326@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Ingo Molnar - Mon, Nov 17, 2008 at 05:52:24PM +0100]
> | 
> | * Yinghai Lu <yinghai@kernel.org> wrote:
> | 
> | > Impact: fix wakeup path with numaq and es7000
> | 
> | applied	to tip/x86/quirks, thanks Yinghai!
> | 
> | A couple of comments:
> | 
> | > +static inline void inquire_remote_apic(int apicid)
> | > +{
> | > +	if (apic_verbosity >= APIC_DEBUG)
> | > +		__inquire_remote_apic(apicid);
> | > +}
> |
> 
> Btw, Ingo, Yinghai,
> 
> it's a bit weird but I found that we use apic_verbosity
> here to _do_ something (ie touching circuit) but on any
> other cases apic_verbosity is just a additional logging
> filter so -- what the initial apic_verbosity purpose was?
> If it's just a logging filter (to which I'm more biased)
> this case is plain wrong. But if apic_verbosity is not
> like this -- then it's fine. Since I was not initial author
> of the code -- I'm asking you :)

the reason why it's dependent on apic_verbosity is that the 
inquire_remote_apic() function is a debug function which we only call 
if we fail to start up a secondary CPU.

Perhaps renaming it to debug_print_remote_apic() would have made that 
more obvious.

	Ingo
