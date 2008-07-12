Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYGLHjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYGLHjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYGLHjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:39:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32879 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbYGLHjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:39:24 -0400
Date: Sat, 12 Jul 2008 09:39:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: apic LVTT - use APIC_DIVISOR on 64bit mode
Message-ID: <20080712073910.GA10689@elte.hu>
References: <20080709190237.GA21423@asus> <20080712060504.GB14714@elte.hu> <20080712072216.GA7010@asus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080712072216.GA7010@asus>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> @@ -329,7 +332,7 @@ static void __init calibrate_APIC_clock(
>  	 *
>  	 * No interrupt enable !
>  	 */
> -	__setup_APIC_LVTT(250000000, 0, 0);
> +	__setup_APIC_LVTT(4000000000, 0, 0);

note how close it is to 2^32. For this to be unifiable later on this 
needs to be UL i guess, and this:

> -	calibration_result = result / HZ;
> +	calibration_result = result * APIC_DIVISOR / HZ;

might overflow 32 bits.

	Ingo
