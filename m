Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbXLRLTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbXLRLTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXLRLTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:19:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41996 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXLRLTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:19:22 -0500
Date: Tue, 18 Dec 2007 12:19:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Use helper in fault_64.c
Message-ID: <20071218111908.GD9002@elte.hu>
References: <1197975535.7734.21.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197975535.7734.21.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Use the fixup_exception() helper in fault_64.c

thanks, applied.

> This is only appropriate if CONFIG_PNP_BIOS cannot be set on X86_64, 
> which looks to be the case, but needs confirmation.

yeah, that seems to be the case:

in drivers/pnp/pnpbios/Kconfig:

 config PNPBIOS
 ...
         depends on ISA && X86 && EXPERIMENTAL

in arch/x86/Kconfig:

 if X86_32
 config ISA

it seems the PNPBIOS has not infested the 64-bit world, so we wont ever 
see this with a 64-bit kernel:

                extern u32 pnp_bios_is_utter_crap;
                pnp_bios_is_utter_crap = 1;
                printk(KERN_CRIT "PNPBIOS fault.. attempting recovery.\n");

	Ingo
