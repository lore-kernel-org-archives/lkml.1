Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbZA2QQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbZA2QQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZA2QPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:15:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49468 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZA2QPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:15:54 -0500
Date: Thu, 29 Jan 2009 17:15:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org
Subject: Re: Possible x2apic breakage
Message-ID: <20090129161546.GB28984@elte.hu>
References: <20090129154146.GA2694@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129154146.GA2694@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> Suresh -
> 
> This popped up in Ingo's x86 tree yesterday. This appears to be breaking
> on our simulator running in x2apic mode. If I understand the code,
> this is a real breakage and not a problem in our simulator:
> 
> 
> arch/x86/include/asm/genapic.h
> 
> 	static inline unsigned int read_apic_id(void)
> 	{
>         	unsigned int reg;
> 
>         	reg = *(u32 *)(APIC_BASE + APIC_ID);
>         	return apic->get_apic_id(reg);
> 	}
> 
> 
> As expected, the failure occurs right after:
> 
> 	Enabling x2apic
> 	Enabled x2apic and interrupt-remapping
> 
> The next reference to apicid tries to read from mem instead of MSRs.

yes - Suresh sent a fix earlier today. Could you please check latest 
tip/master (v2.6.29-rc3-1212-g69f3c6d or later), does it work fine in your 
simulator?

And i'll also merge struct apic_ops into struct genapic - now that genapic 
is unified there's no reason for the two to be separate.

	Ingo
