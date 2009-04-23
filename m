Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbZDWRat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbZDWRat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbZDWRa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:30:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60096 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbZDWRa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:30:27 -0400
Message-ID: <49F0A5AF.5080906@us.ibm.com>
Date: Thu, 23 Apr 2009 10:30:23 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ravikiran G Thirumalai <kiran@scalex86.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, shai@scalex86.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc] [patch 1/2 ] Process private hash tables for private	futexes
References: <20090321044637.GA7278@localdomain> <49C4AE64.4060400@cosmosbay.com> <20090322045414.GD7278@localdomain> <49C5F3FD.9010606@cosmosbay.com> <20090323202837.GE7278@localdomain> <49C805E3.4060808@cosmosbay.com> <49C88616.9030307@cosmosbay.com>
In-Reply-To: <49C88616.9030307@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

> 
> +	futex_queues = alloc_large_system_hash("futexes",
> +			sizeof(struct futex_hash_bucket),
> +			nr_slots,
> +			0, /* scale : unused */
> +			0, /* flags */
> +			NULL, /* shift */
> +			&futex_hash_mask,
> +			nr_slots);

OK, so I'm a little late to the party, apologies.

Minor nit (from someone who has been spending a lot of time in futex.c
trying to clean things up recently :-).  Let's not comment each argument
individually.  It needlessly lengthens the code.  The interested user
can easily look up alloc_large_system_hash.  If you feel a comment is
really needed, consider a single line before the call... I gave this
some thought and couldn't think of anything you could put there that
wouldn't still send the interested reader over to page_alloc.c.

/* Allocate futex hashtable with... <whatever is special about this> */
futex_queues = alloc_large_system_hash("futexes",
				       sizeof(struct futex_hash_bucket),
				       nr_slots, 0, 0, NULL, &futex_hash_mask,
				       nr_slots);

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
