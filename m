Return-Path: <linux-kernel-owner+w=401wt.eu-S1764210AbZDCNQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764210AbZDCNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZDCNQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:16:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZDCNQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:16:46 -0400
Date: Fri, 3 Apr 2009 15:16:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] tracing: fix splice return too large
Message-ID: <20090403131629.GA8875@elte.hu>
References: <49D46674.9030804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D46674.9030804@cn.fujitsu.com>
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> -	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= size) {
> +	if (*ppos & (PAGE_SIZE - 1)) {
> +		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
> +		return -EINVAL;
> +	}
> +
> +	if (len & (PAGE_SIZE - 1)) {
> +		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
> +		if (len < PAGE_SIZE)
> +			return -EINVAL;
> +		len &= PAGE_MASK;
> +	}

Hm, the fix looks good, but is it a good idea to allow the 
triggering of this message from user-space?

	Ingo
