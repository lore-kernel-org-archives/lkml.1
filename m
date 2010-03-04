Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0CDRSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:18:00 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:33392 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0CDRR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:17:58 -0500
Date: Thu, 4 Mar 2010 12:32:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, paulus@samba.org,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, robert.richter@amd.com,
       eranian@gmail.com, davem@davemloft.net,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf_events: add sampling period randomization support
 (v2)
Message-ID: <20100304113212.GG21977@elte.hu>
References: <1267575705-10054-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267575705-10054-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* eranian@google.com <eranian@google.com> wrote:

> This patch adds support for randomizing the sampling period.  Randomization 
> is very useful to mitigate the bias that exists with sampling. The random 
> number generator does not need to be sophisticated. This patch uses the 
> builtin random32() generator.

> +	if (width > 63 || attr->freq)
> +		return -EINVAL;

Why not for freq counters? Those are semi-randomized already, but it might 
make sense to make them 'more' randomized in special circumstances. That would 
also allow us to enable the randomization in perf top and perf record, by 
default.

Without that we'd have no immediate usecase and no way to ensure that this 
code works as intended.

Thanks,

	Ingo
