Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbXGKGQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbXGKGQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbXGKGQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:16:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:48414 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbXGKGQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:16:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hcFqL+zBOL+XIGVrSlKihSR5NUgKBEJm2Wcn2Q9124vLoyJMjVPLcE+RO5g0Q0lZVpXX3OQoVLU6YtUKURO95T9pIbPmAFWw165ZmK5OLXbEs2EFLMu+8gKYF/gBkEcuGQcYo5X7DjsKNtiKpovstY7yi+scvHvSPkbZ8K8p5r0=
Message-ID: <2c0942db0707102247n3b6e5933i9803a2161d6c00b1@mail.gmail.com>
Date: Tue, 10 Jul 2007 22:47:04 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: "Matthew Hawkins" <darthmdh@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <4694683B.3060705@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <200707102015.44004.kernel@kolivas.org>
	 <b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>
	 <20070710181419.6d1b2f7e.akpm@linux-foundation.org>
	 <b21f8390707101954s3ae69db8vc30287277941cb1f@mail.gmail.com>
	 <4694683B.3060705@yahoo.com.au>
X-Google-Sender-Auth: 4c07636ee3d74d83
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Matthew Hawkins wrote:
> > On 7/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > Anyhow with swap prefetch, applications that may have been sitting
> > there idle for a while become responsive in the single-digit seconds
> > rather than double-digit or worse.  The same goes for a morning wakeup
> > (ie after nightly cron jobs throw things out)
>
> OK that's a good data point. It would be really good to be able to
> do an analysis on your overnight IO patterns and the corresponding
> memory reclaim behaviour and see why things are getting evicted.

Eviction can happen for multiple reasons, as I'm sure you're painfully
aware. It can happen because of poor balancing choices, or it can
happen because the system is just short of RAM for the workload. As
for the former, you're absolutely right, it would be good to know
where those come from and see if they can be addressed.

However, it's the latter that swap prefetch can help and no amount of
fiddling with the aging code can address.

As an honest question, what's it going to take here? If I were to
write something that watched the task stats at process exit (cool
feature, that), and recorded the IO wait time or some such, and showed
it was lower with a kernel with the prefetch, would *that* get us some
forward motion on this?

I mean, from my point of view, it's a simple mental proof to show that
if you're out of RAM for your working set, things that you'll
eventually need again will get kicked out, and prefetch will bring
those back in before normal access patterns would fault them back in
under today's behavior. That seems like an obvious win. Where's the
corresponding obvious loss that makes this a questionable addition to
the kernel?

Ray
