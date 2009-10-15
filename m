Return-Path: <linux-kernel-owner+w=401wt.eu-S935086AbZJOJcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935086AbZJOJcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934663AbZJOJcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:32:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934191AbZJOJcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:32:46 -0400
Date: Thu, 15 Oct 2009 11:31:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v7 4/5]: core: Add kernel message dumper to call on
	oopses and panics
Message-ID: <20091015093133.GF10546@elte.hu>
References: <20091015094057.7298e0d7@marrow.netinsight.se> <20091015094805.754461fa@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015094805.754461fa@marrow.netinsight.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> --- /dev/null
> +++ b/include/linux/kmsg_dump.h

> +enum kmsg_dump_reason {
> +	kmsg_dump_oops,
> +	kmsg_dump_panic,
> +};

Please capitalize constants - lower case suggests it's some sort of 
variable which it is not.

> +void dump_kmsg(enum kmsg_dump_reason reason);
> +
> +int register_kmsg_dumper(struct kmsg_dumper *dumper);
> +
> +void unregister_kmsg_dumper(struct kmsg_dumper *dumper);

Please rename these APIs to be more in line with how we name new kernel 
APIs. Something like:

  kmsg_dump()
  kmsg_dumper_register()
  kmsg_dumper_unregister()

(we start with the subsystem as a prefix, then we go from more generic 
to less generic words.)

Might even make sense to name them all kmsg_dump:

  kmsg_dump()
  kmsg_dump_register()
  kmsg_dump_unregister()

Thanks,

	Ingo
