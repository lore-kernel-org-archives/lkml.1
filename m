Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbZJIN4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbZJIN4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbZJIN4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:56:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58275 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZJIN4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:56:41 -0400
Date: Fri, 9 Oct 2009 15:55:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for
	Intel processors
Message-ID: <20091009135552.GA1695@elte.hu>
References: <1254840129-6198-1-git-send-email-eranian@gmail.com> <1254840129-6198-2-git-send-email-eranian@gmail.com> <1254840129-6198-3-git-send-email-eranian@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254840129-6198-3-git-send-email-eranian@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0885]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@googlemail.com> wrote:

> +struct evt_cstr {
> +	unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> +	int		code;
> +};
> +
> +#define EVT_CSTR0(c, m) { .code = (c), .idxmsk[0] = (m) }
> +#define EVT_CSTR_END  { .code = 0, .idxmsk[0] = 0 }
> +
> +#define for_each_evt_cstr(e, c) \
> +	for((e) = (c); (e)->idxmsk[0]; (e)++)

Nice patch - but the naming here absolutely sucked, so i changed 
evt_cstr, idxmsk, CSTR, etc. to something more palatable. Field names 
and abstractions in Linux code really need to be meaningful, and the 
code has to be readable and understandable. Wdntusabbrntslkthtinlnx :)

	Ingo
