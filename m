Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbYCKXnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbYCKXnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYCKXnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:43:17 -0400
Received: from n1a.bullet.mail.tp2.yahoo.com ([203.188.202.90]:27660 "HELO
	n1a.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750932AbYCKXnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:43:16 -0400
X-Yahoo-Newman-Id: 787761.60739.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IR8URbMPqwtn3v+mtho++Rmz2I/TXZe4sMPqIUPmbtPGPoJQ0E2LLwKzlYJ/wiQVH23IxviEEkdEL64slo7ZoD0ncTZiprYNHxMyFQkB5OwkleVSiDO4VoLWDS3JNaeeGAwy/VagdeLYIVFYmkwJxY5mpGCmOuxjy36BkWoIAl0=  ;
X-YMail-OSG: 3HD0FJYVM1nfgukJSjnymFQDgm32wNNoDQXyt993Yzsh7n2pqe8bpXQeN7PmL9Bt_.9cVJo8Qw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Nicholas Miell <nmiell@comcast.net>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Date: Wed, 12 Mar 2008 10:42:43 +1100
User-Agent: KMail/1.9.5
Cc: Cyrus Massoumi <cyrusm@gmx.net>, "Molnar, Ingo" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <47D6FAD0.1020608@gmx.net> <1205277132.12854.19.camel@entropy>
In-Reply-To: <1205277132.12854.19.camel@entropy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121042.43895.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 10:12, Nicholas Miell wrote:
> On Tue, 2008-03-11 at 22:34 +0100, Cyrus Massoumi wrote:

> Piggin said the following:
> > The problem with MySQL contention means that if the scheduler
> > unluckily chooses to deschedule a lock holder, then you can get
> > idle time building up on other cores and you can get context switch
> > cascades as things all pile up onto this heavily contended lock. As
> > such, it means MySQL is not an ideal candidate for looking at
> > performance behaviour. I discounted the relatively worse scaling of
> > MySQL with 2.6.25-rc (than 2.6.22) as such an effect.
>
> which I interpreted to mean that MySQL performs worse on 2.6.23+ than on
> 2.6.22 but for some reason this doesn't matter.

I didn't try 2.6.23, which I think has bigger problems due to new
CFS code. 2.6.25-rc fixes that, but yes in general I think the MySQL
performance profile is worse on later kernels: while it has a
very slightly higher peak performance, it drops off in performance
more quickly after that peak. I initially wasn't too worried about
it, but seeing as postgresql has a similar problem, I've made the
scheduler developers aware of it.

