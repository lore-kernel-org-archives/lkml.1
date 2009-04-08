Return-Path: <linux-kernel-owner+w=401wt.eu-S1765884AbZDHOwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765884AbZDHOwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbZDHOwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:52:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52618 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbZDHOwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:52:34 -0400
Date: Wed, 8 Apr 2009 16:52:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH -tip] x86: do_IRQ - send EOI for x86-32 on irq without
	handler v2
Message-ID: <20090408145218.GM12931@elte.hu>
References: <20090408145017.GB7556@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408145017.GB7556@lenovo>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Ingo, I think introducing additional dummy here would be a bit 
> expencive -- a number of callers of ack_APIC_irq just should not 
> check for disable_apic since it's not needed. disable_apic is to 
> depend on CONFIG_X86_LOCAL_APIC rather then CONFIG_X86_64 
> actually. So make it then. Or you mean something else? Like new 
> apic->write_eoi operation? (I'm a bit tired so brain is a half 
> functional now :)

no, i meant a dummy apic->write() method in the !apic case. Check 
what ack_APIC_irq() does internally.

	Ingo
