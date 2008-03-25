Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYCYObX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYCYObX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYCYObP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:31:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46495 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbYCYObP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:31:15 -0400
Date: Tue, 25 Mar 2008 15:30:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Message-ID: <20080325143059.GB11323@elte.hu>
References: <20080324182122.GA28327@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324182122.GA28327@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> Index: linux/arch/x86/kernel/genapic_64.c

> @@ -69,7 +73,16 @@ void send_IPI_self(int vector)
>  
>  unsigned int get_apic_id(void)
>  {
> -	return (apic_read(APIC_ID) >> 24) & 0xFFu;
> +	unsigned int id;
> +
> +	preempt_disable();
> +	id = apic_read(APIC_ID);
> +	if (uv_system_type >= UV_X2APIC)
> +		id  |= __get_cpu_var(x2apic_extra_bits);
> +	else
> +		id = (id >> 24) & 0xFFu;;
> +	preempt_enable();
> +	return id;

dont we want to put get_apic_id() into struct genapic instead? We 
already have ID management there.

also, we want to unify 32-bit and 64-bit genapic code and just have 
genapic all across x86.

	Ingo
