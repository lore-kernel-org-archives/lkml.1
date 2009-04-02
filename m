Return-Path: <linux-kernel-owner+w=401wt.eu-S933998AbZDBAUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998AbZDBAUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbZDBAUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:20:35 -0400
Received: from ozlabs.org ([203.10.76.45]:56903 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150AbZDBAUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:20:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default percpu allocator
Date: Thu, 2 Apr 2009 10:50:28 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090401101054.0a4b187d@skybase> <49D3231D.2040403@kernel.org>
In-Reply-To: <49D3231D.2040403@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904021050.30070.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009 18:47:33 Tejun Heo wrote:
> Martin Schwidefsky wrote:
> > Is the goal to use the same access macros for both dynamically and
> > statically allocated percpu variables? That would make the proposed
> > solution impractical.
> 
> Yeah, it's one of the goals so that we don't have to have two sets of
> APIs (e.g. the fast percpu_*() accessors).

There's a weaker, but still useful, subset of this goal: to allow the
ptr versions to access any var (ie. you can do "DEFINE_PER_CPU(int, foo);
... some_func(&foo)) yet still have the get_cpu_var() be the optimized
actual-variable versions.

Don't know that the distinction is *useful* here tho...
Rusty.


