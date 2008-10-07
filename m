Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYJGDmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYJGDmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 23:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYJGDmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 23:42:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46409 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYJGDmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 23:42:00 -0400
Date: Tue, 7 Oct 2008 05:41:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86: SB450: skip IRQ0 override if it is not routed to
	INT2 of IOAPIC
Message-ID: <20081007034132.GA3025@elte.hu>
References: <20081005183603.GA3263@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu> <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org> <20081006221122.GC22097@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006221122.GC22097@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> So, let's work around BIOS bugs in Linux then ...
> 
> Following patch is almost untested -- especially I didn't get my hands 
> on one of the HP Laptops with broken DSDT.
[...]
> On some HP nx6... laptops (e.g. nx6325) BIOS reports an IRQ0 override 
> but the SB450 chipset is configured such that timer interrupts goe to 
> INT0 of IOAPIC.
> 
> Check IRQ0 routing and if it is routed to INT0 of IOAPIC skip the 
> timer override.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
>
> ---
>  arch/x86/kernel/early-quirks.c |   48 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)

very nice, thanks Andreas! Applied to tip/x86/quirks. This PCI ID based 
quirk should be more complete than DMI matches.

	Ingo
