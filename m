Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYKJH7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYKJH7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYKJH6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:58:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34142 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYKJH6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:58:52 -0500
Date: Mon, 10 Nov 2008 08:58:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Nobin Mathew <nobin.mathew@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: sharing interrupt between PCI device
Message-ID: <20081110075827.GE2093@elte.hu>
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no> <4910E8AC.7050407@shaw.ca> <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com> <20081108172716.GA28039@colo.lackof.org> <4915E43E.4010206@gmail.com> <20081108191536.GC28039@colo.lackof.org> <8d6898730811092235u4a41c664vd641d2792dee4c50@mail.gmail.com> <20081110075115.GA13239@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110075115.GA13239@colo.lackof.org>
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


* Grant Grundler <grundler@parisc-linux.org> wrote:

> [+ingo - question for you about disable_irq() below]

> The same problem exists with disable_irq() : only takes a global
> IRQ# and no additional identifying information to prevent disabling
> a shared IRQ. So I'm not sure if this is a bug with ACPI or design
> flaw in generic IRQ APIs.  Ingo?

that's how disable_irq() always worked: it disables all handlers on 
that IRQ#. If the IRQ# is shared, it disables all handlers.

	Ingo
