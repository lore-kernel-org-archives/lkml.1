Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbZDLItN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbZDLItN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 04:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbZDLIs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 04:48:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50238 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856AbZDLIs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 04:48:56 -0400
Date: Sun, 12 Apr 2009 10:48:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] readahead: introduce context readahead algorithm
Message-ID: <20090412084819.GA25314@elte.hu>
References: <20090412071950.166891982@intel.com> <20090412072052.686760755@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412072052.686760755@intel.com>
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


* Wu Fengguang <fengguang.wu@intel.com> wrote:

> Introduce page cache context based readahead algorithm.
> This is to better support concurrent read streams in general.

>  /*
> + * Count contiguously cached pages from @offset-1 to @offset-@max,
> + * this count is a conservative estimation of
> + * 	- length of the sequential read sequence, or
> + * 	- thrashing threshold in memory tight systems
> + */
> +static pgoff_t count_history_pages(struct address_space *mapping,
> +				   struct file_ra_state *ra,
> +				   pgoff_t offset, unsigned long max)
> +{
> +	pgoff_t head;
> +
> +	rcu_read_lock();
> +	head = radix_tree_prev_hole(&mapping->page_tree, offset - 1, max);
> +	rcu_read_unlock();
> +
> +	return offset - 1 - head;
> +}

Very elegant method! I suspect this will work far better 
than adding various increasingly more complex heuristics.

Emphatically-Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
