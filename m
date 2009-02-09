Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZBIIQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZBIIQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZBIIP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:15:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53042 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZBIIP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:15:57 -0500
Date: Mon, 9 Feb 2009 09:15:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: check_timer cleanup
Message-ID: <20090209081542.GF24420@elte.hu>
References: <20090206220716.GA15319@elte.hu> <498D55A4.7000608@kernel.org> <20090207165901.GA32116@elte.hu> <498E6A3C.6020004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498E6A3C.6020004@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: remove extra unmask, and pair disable/enable
> 
> for edge trigger io-apic routing, already unmasked via setup_IO_APIC_irq,
> so don't unmask it again.
> 
> also do call local_irq_disable() between timer_irq_works(), between it does call
> local_irq_enable() inside.
> also remove not needed apic version reading for 64bit
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/io_apic.c |   30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)

applied to tip/x86/apic, thanks Yinghai. Maybe this even solves some of the spurious 
detection troubles we had in this code.

	Ingo
