Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZFJFMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZFJFMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbZFJFMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:12:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:35554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbZFJFMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:12:42 -0400
Message-ID: <4A2F40A3.5020602@kernel.org>
Date: Wed, 10 Jun 2009 14:12:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [this_cpu_xx 01/11] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
References: <20090605191819.376530498@gentwo.org> <20090605191850.441840884@gentwo.org>
In-Reply-To: <20090605191850.441840884@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 10 Jun 2009 05:12:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

cl@linux-foundation.org wrote:
...
> The operations are guaranteed to be atomic vs preemption if they modify
> the scalar (unless they are prefixed by __ in which case they do not need
> to be). The calculation of the per cpu offset is also guaranteed to be atomic.
> 
> this_cpu_read(scalar)
> this_cpu_write(scalar, value)
> this_cpu_add(scale, value)
> this_cpu_sub(scalar, value)
> this_cpu_inc(scalar)
> this_cpu_dec(scalar)
> this_cpu_and(scalar, value)
> this_cpu_or(scalar, value)
> this_cpu_xor(scalar, value)

Looks good to me.  The only qualm I have is that I wish these macros
take pointer instead of the symbol name directly.  Currently it's not
possible due to the per_cpu__ appending thing but those should go with
Rusty's patches and the same ops should be useable for both static and
dynamic ones.  One problem which may occur with such scheme is when
the arch+compiler can't handle indirect dereferencing atomically.  At
any rate, it's a separate issue and we can deal with it later.

Thanks.

-- 
tejun
