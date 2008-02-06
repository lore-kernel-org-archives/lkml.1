Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbYBFXhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbYBFXhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759223AbYBFXhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:37:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57669 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759127AbYBFXhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:37:42 -0500
Date: Thu, 7 Feb 2008 00:36:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       tglx@linutronix.de, mingo@redhat.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in
	die_nmi path
Message-ID: <20080206233657.GB12393@elte.hu>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com> <47AA3B16.7000507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AA3B16.7000507@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

>> I am wondering if interrupts are disabled on crashing cpu or if 
>> crashing cpu is inside die_nmi(), how would it stop/prevent delivery 
>> of NMI IPI to other cpus.
>
> I don't see how it would.

cross-CPU IPIs are a bit fragile on some PC platforms. So if the kexec 
code relies on getting IPIs to all other CPUs, it might not be able to 
do it reliably. There might be limitations on how many APIC irqs there 
can be queued at a time, and if those slots are used up and the CPU is 
not servicing irqs then stuff gets retried. This might even affect NMIs 
sent via APIC messages - not sure about that.

	Ingo
