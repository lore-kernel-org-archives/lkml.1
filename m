Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbXCQHX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbXCQHX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 03:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXCQHX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 03:23:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59128 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbXCQHXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 03:23:55 -0400
Date: Sat, 17 Mar 2007 08:22:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] i386: trust the PM-Timer calibration of the local APIC timer
Message-ID: <20070317072227.GA12122@elte.hu>
References: <200703161230.03712.maximlevitsky@gmail.com> <1174088686.13341.347.camel@localhost.localdomain> <1174089896.13341.362.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174089896.13341.362.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> When PM-Timer is available for local APIC timer calibration we can 
> skip the verification of the calibrated time value. The resulting 
> error is quite small on a bunch of evaluated platforms and is less 
> harming than the observed false positives.
> 
> We need to keep the verification on systems, which have no PM-Timer to 
> avoid bogus local APIC timer calibrations in the range of factor 2-10, 
> which can be observed when swicthing off the PM-timer support in the 
> kernel configuration.
> 
> The wrong calibration values are probably caused by SMM code trying to 
> emulate a PS/2 keyboard from a (maybe connected or not) USB keyboard. 
> This prohibits the accurate delivery of PIT interrupts, which are used 
> to calibrate the local APIC timer. Unfortunately we have no way to 
> disable this BIOS misfeature in the early boot process.
> 
> Add also the dropped cpu_relax() back to the wait loops.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
