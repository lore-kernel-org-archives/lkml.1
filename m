Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYGZPkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYGZPkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYGZPko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:40:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41789 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYGZPko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:40:44 -0400
Date: Sat, 26 Jul 2008 17:40:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take 3)
Message-ID: <20080726154029.GA15945@elte.hu>
References: <48889C14.4070408@fujitsu-siemens.com> <4889968E.6020000@fujitsu-siemens.com> <20080725100844.GA16698@lenovo> <4889C723.7050402@fujitsu-siemens.com> <20080725125950.GA28466@lenovo> <4889D767.5050709@fujitsu-siemens.com> <20080725134831.GB28466@lenovo> <4889DCA4.4010800@fujitsu-siemens.com> <20080725150104.GD28466@lenovo> <4889ED91.7050800@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4889ED91.7050800@fujitsu-siemens.com>
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


* Martin Wilck <martin.wilck@fujitsu-siemens.com> wrote:

> [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take 3)
> 
> Non-maskable asynchronous events (e.g. SMIs) which occur during the 
> APIC timer calibration can cause timer miscalibrations, sometimes by 
> large amounts. This patch fixes this by making sure that no 
> significant interruption occurs between APIC and TSC reads. SMIs may 
> still occur at some stage in the calibration loop, causing the loop to 
> last longer than intended. This doesn't matter though, as long as the 
> start and end values are both taken simultaneously.
> 
> Changed wrt take 2: Use max. possible start value for the APIC timer 
> to avoid underflow.
> 
> Signed-off-by: Martin Wilck <martin.wilck@fujitsu-siemens.com>
> Signed-off-by: Gerhard Wichert <gerhard.wichert@fujitsu-siemens.com>
> 
> --- arch/x86/kernel/apic_64.c	2008-07-25 15:39:51.000000000 +0200
> +++ arch/x86/kernel/apic_64.c.new	2008-07-25 15:55:08.000000000 +0200

nice - could you please implement it symmetrically on 32-bit APIC 
calibration as well?

	Ingo
