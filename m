Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZCaFp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZCaFp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 01:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZCaFpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 01:45:32 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53194 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbZCaFpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 01:45:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18897.44531.88862.844627@cargo.ozlabs.ibm.com>
Date: Tue, 31 Mar 2009 16:45:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] perf_counter: unify and fix delayed counter wakeup
In-Reply-To: <20090330171023.153932974@chello.nl>
References: <20090330170701.856843742@chello.nl>
	<20090330171023.153932974@chello.nl>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> +void perf_counter_wakeup(struct perf_counter *counter)
> +{
> +	struct perf_mmap_data *data;
> +
> +	rcu_read_lock();
> +	data = rcu_dereference(counter->data);
> +	if (data) {
> +		(void)atomic_xchg(&data->wakeup, POLL_IN);

Really just a nit, but how is this atomic_xchg any different from
atomic_set(&data->wakeup, POLL_IN) aside from being slower?

Paul.
