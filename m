Return-Path: <linux-kernel-owner+w=401wt.eu-S934766AbZAPBKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766AbZAPBKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760935AbZAPBJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:09:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935260AbZAPBJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:09:29 -0500
Message-ID: <496FDE53.7010104@zytor.com>
Date: Thu, 15 Jan 2009 17:09:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       tj@kernel.org, brgerst@gmail.com, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
References: <20090115183942.GA6325@elte.hu> <20090116001200.GA9137@gondor.apana.org.au> <20090116001544.GA11073@elte.hu>
In-Reply-To: <20090116001544.GA11073@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>
>> So if you could design the API such that we have a variant of add/inc 
>> that automatically disables/enables preemption then we can optimise that 
>> away on x86.
> 
> Yeah. percpu_add(var, 1) does exactly that on x86.
> 

And even on architectures which can only do percpu inc/dec we can make 
the right thing happen for a constant here, so we really don't need a 
new interface.  This is a good thing.

	-hpa
