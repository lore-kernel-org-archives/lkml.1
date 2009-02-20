Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZBTR67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZBTR67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZBTR6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:58:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59883 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZBTR6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:58:50 -0500
Date: Fri, 20 Feb 2009 18:58:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86, vmi: TSC going backwards check in vmi clocksource
Message-ID: <20090220175841.GQ24538@elte.hu>
References: <1234989235.7991.2.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234989235.7991.2.camel@alok-dev1>
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


* Alok Kataria <akataria@vmware.com> wrote:

>  static cycle_t read_real_cycles(void)
>  {
> -	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
> +	cycle_t ret = (cycle_t)vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
> +	return ret >= clocksource_vmi.cycle_last ?
> +		ret : clocksource_vmi.cycle_last;

btw., could you please clean this up to use max()?

	Ingo
