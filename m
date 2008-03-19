Return-Path: <linux-kernel-owner+w=401wt.eu-S941347AbYCSXQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941347AbYCSXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933329AbYCSVmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:42:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52746 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938145AbYCSVmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:42:44 -0400
Date: Wed, 19 Mar 2008 22:42:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2/2] vmallocinfo: Add caller information
Message-ID: <20080319214227.GA4454@elte.hu>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318222827.519656153@sgi.com>
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


* Christoph Lameter <clameter@sgi.com> wrote:

> Add caller information so that /proc/vmallocinfo shows where the 
> allocation request for a slice of vmalloc memory originated.

please use one simple save_stack_trace() instead of polluting a dozen 
architectures with:

> -	return __ioremap(phys_addr, size, IOR_MODE_UNCACHED);
> +	return __ioremap_caller(phys_addr, size, IOR_MODE_UNCACHED,
> +						__builtin_return_address(0));

	Ingo
