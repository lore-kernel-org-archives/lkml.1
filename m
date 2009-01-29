Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbZA2CH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbZA2CH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 21:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZA2CHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 21:07:01 -0500
Received: from ozlabs.org ([203.10.76.45]:43521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbZA2CG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 21:06:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Date: Thu, 29 Jan 2009 12:36:46 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Herbert Xu <herbert@gondor.apana.org.au>,
       akpm@linux-foundation.org, hpa@zytor.com, brgerst@gmail.com,
       ebiederm@xmission.com, cl@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com, hugh@veritas.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <20090115183942.GA6325@elte.hu> <200901282108.51864.rusty@rustcorp.com.au> <498039E2.7090107@kernel.org>
In-Reply-To: <498039E2.7090107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291236.48189.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009 21:26:34 Tejun Heo wrote:
> Hello,

Hi Tejun,

> Rusty Russell wrote:
> > If the stats are only manipulated in one context, than an atomic
> > requirement is overkill (and expensive on non-x86).
> 
> Yes, it is.  I was hoping it to be not more expensive on most archs.
> It isn't on x86 at the very least but I don't know much about other
> archs.

Hmm, you can garner this from the local_t stats which were flying around.
(see Re: local_add_return from me), or look in the preamble to
http://ozlabs.org/~rusty/kernel/rr-latest/misc:test-local_t.patch ).

Of course, if you want to be my hero, you could implement "soft" irq
disable for all archs, which would make this cheaper.

> > Other than the shouting, I liked Christoph's system:
> > - CPU_INC = always safe (eg. local_irq_save/per_cpu(i)++/local_irq_restore)
> > - _CPU_INC = not safe against interrupts (eg. get_cpu/per_cpu(i)++/put_cpu)
> > - __CPU_INC = not safe against anything (eg. per_cpu(i)++)
> > 
> > I prefer the name 'local' to the name 'cpu', but I'm not hugely fussed.
> 
> I like local better too but no biggies one way or the other.

Maybe kill local_t and take the name back.  I'll leave it to you...

> > Ah, I did not realize that you celebrated Australia day :)
> 
> Hey, didn't know Australia was founded on lunar New Year's day.
> Nice. :-)

That would have been cool, but no; first time in 76 years they matched tho.

Thanks,
Rusty.
