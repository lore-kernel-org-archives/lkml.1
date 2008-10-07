Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYJGRJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYJGRJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYJGRJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:09:20 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:3997 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423AbYJGRJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:09:19 -0400
Message-ID: <48EB97B2.3010406@rsk.demon.co.uk>
Date: Tue, 07 Oct 2008 18:09:06 +0100
From: richard kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH, RFC] percpu_counters: make fbc->count read atomic on
   32 bit architecture
References: <E1KmetO-00053M-5u@closure.thunk.org>	 <20081006232322.c383fac5.akpm@linux-foundation.org> <1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
....
> +static inline int atomic64_dec_and_test(atomic64_t *v)
> +{
> +	int ret;
> +
> +	write_seqlock(&v->slock);
> +	v->counter--;
> +	ret = !v->counter;
> +	write_sequnlock(&v->slock);
> +
> +	return ret;
> +}
> +
> +static inline int atomic64_add_and_test(atomic64_t *v)
> +{
> +	int ret;
> +
> +	write_seqlock(&v->slock);
> +	v->counter++;
> +	ret = !v->counter;
> +	write_sequnlock(&v->slock);
> +
> +	return ret;
> +}
would it be more logical to call this atomic64_inc_and_test to match the
above dec_and_test ?

regards
Richard
