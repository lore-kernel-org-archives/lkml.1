Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbZAPAMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbZAPAMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZAPAMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:12:39 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44191 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754153AbZAPAMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:12:38 -0500
Date: Fri, 16 Jan 2009 11:12:00 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, tj@kernel.org, hpa@zytor.com, brgerst@gmail.com,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, steiner@sgi.com,
       hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Message-ID: <20090116001200.GA9137@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115183942.GA6325@elte.hu>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:
>
>> Of course.  But do any architectures actually _need_ that for a single 
>> read?
> 
> not for a read i guess - but for the other ops like add/and/or/xor.

One of the things I'd like to see happen with this work is for
us to have a cheap per-cpu atomic counter that we can use for
SNMP stats.

If we can make the inc/add variants into a single instruction,
then it won't need to disable preemption or interrupts.

So if you could design the API such that we have a variant of
add/inc that automatically disables/enables preemption then we
can optimise that away on x86.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
