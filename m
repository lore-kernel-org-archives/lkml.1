Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYHSAJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYHSAJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYHSAJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:09:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbYHSAJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:09:26 -0400
Date: Tue, 19 Aug 2008 02:09:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, macro@linux-mips.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/15] apic: unification series 5
Message-ID: <20080819000910.GA9914@elte.hu>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com> <48A9AFC4.8060505@zytor.com> <20080818191233.GA31466@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080818191233.GA31466@lenovo>
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

> [H. Peter Anvin - Mon, Aug 18, 2008 at 10:22:12AM -0700]
> > Cyrill Gorcunov wrote:
> >>
> >> With this series 32bit code compilation warns:
> >>
> >> arch/x86/kernel/apic_32.c: In function ‘end_local_APIC_setup’:
> >> arch/x86/kernel/apic_32.c:1165: warning: ISO C90 forbids mixed declarations and code
> >> arch/x86/kernel/apic_32.c: In function ‘disconnect_bsp_APIC’:
> >> arch/x86/kernel/apic_32.c:1446: warning: ISO C90 forbids mixed declarations and code
> >> cyrill@lenovo linux-2.6.git $ 
> >>
> >> So parenthesis will be needed to eliminate them... but
> >> I think it could be too ugly... need some time to think.
> >> So patches 8/15 and 10/15 sould be not applied for now - just review them.
> >> Thanks for patience!
> >>
> >
> > Typically, just move the declaration to the top of the function  
> > (followed by a blank line.)
> >
> > 	-hpa
> >
> Here is compilation warnings fix

applied the 15 patches and this fixlet to tip/x86/apic - thanks Cyrill.

> Please check if it's not worse code form now :)

> +	{
> +		unsigned int value;
> +		/* Disable the local apic timer */
> +		value = apic_read(APIC_LVTT);
> +		value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
> +		apic_write(APIC_LVTT, value);
> +	}

that's OK.

	Ingo
