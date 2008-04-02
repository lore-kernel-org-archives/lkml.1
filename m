Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbYDBQQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbYDBQQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYDBQP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:15:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:6478 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbYDBQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CXpzqCAIISUEj6SwLrEoEU+JcFuRGKktYjv2qMVKk6QS0TXw3l0zGLSCi9ij2eqa2D1cl+qw7pf3+RJY32Pk2iTzo6RdWhsqi8xa/7mh2eOLkZCIrMsj75ucqKnEewjrkvFPWtxuOV9YJjLvGivM4My+CofCG5buggUesVC2bC0=
Message-ID: <19f34abd0804020915k210277bbmb6b9aa28f282bb42@mail.gmail.com>
Date: Wed, 2 Apr 2008 18:15:52 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080402160809.GA4123@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com>
	 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk>
	 <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI>
	 <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu>
	 <20080402105539.GA5610@linux.vnet.ibm.com>
	 <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
	 <20080402160809.GA4123@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 6:08 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Apr 02, 2008 at 02:01:13PM +0300, Pekka Enberg wrote:
>  > No, kmemcheck is work in progress and does not know about
>  > SLAB_DESTROY_BY_RCU yet. The reason I asked Vegard to post the warning
>  > was because Peter, Vegard, and myself identified this particular
>  > warning as a real problem. But yeah, kmemcheck can cause false
>  > positives for RCU for now.
>
>  Would the following be an appropriate fix?  It seems to me to be in
>  the same spirit as the existing check for s->ctor.

In my opinion, no.

It would fix the false positives, but would in fact also hide cases
such as this one with cfq, e.g. the real cases of mis-use.

Peter Zijlstra suggested this:
> It would have to register an call_rcu callback itself in order to mark
> it freed - and handle the race with the object being handed out again.

I will try to look into this -- for now, I need to understand RCU
first (I've seen your LWN articles -- great work! :-))


Kind regards,
Vegard Nossum
