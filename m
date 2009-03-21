Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZCUJnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZCUJnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 05:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZCUJnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 05:43:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbZCUJnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 05:43:12 -0400
Date: Sat, 21 Mar 2009 10:42:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perfcounters: fix type/event_id layout on big-endian
	systems
Message-ID: <20090321094246.GA5594@elte.hu>
References: <18884.29385.854691.357234@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18884.29385.854691.357234@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

>  struct perf_counter_hw_event {
>  	union {
> +#ifndef __BIG_ENDIAN_BITFIELD
>  		struct {
>  			__u64			event_id	: 56,
>  						type		:  8;
> @@ -94,6 +96,16 @@ struct perf_counter_hw_event {
>  			__u64			raw_event_id	: 63,
>  						raw_type	:  1;
>  		};
> +#else
> +		struct {
> +			__u64			type		:  8,
> +						event_id	: 56;
> +		};
> +		struct {
> +			__u64			raw_type	:  1,
> +						raw_event_id	: 63;
> +		};
> +#endif /* __BIT_ENDIAN_BITFIELD */

hm, this ifdef really looks ugly. How about just changing event_id 
to 64 bits and having a separate u32 type field? The size impact is 
minimal, the cleanliness win is significant :-)

	Ingo
