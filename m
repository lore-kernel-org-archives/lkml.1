Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZBRHLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZBRHLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 02:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZBRHLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 02:11:23 -0500
Received: from ozlabs.org ([203.10.76.45]:55126 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZBRHLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 02:11:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: #tj-percpu has been rebased
Date: Wed, 18 Feb 2009 17:41:13 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
References: <49833350.1020809@kernel.org> <200902181455.11572.rusty@rustcorp.com.au> <499BAD54.3050108@zytor.com>
In-Reply-To: <499BAD54.3050108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181741.13736.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 17:10:20 H. Peter Anvin wrote:
> Rusty Russell wrote:
> >>>
> >> num_possible_cpus() can be very large though, so in many cases the
> >> likelihood of finding that many pages approach zero.  Furthermore,
> >> num_possible_cpus() may be quite a bit larger than the actual number of
> >> CPUs in the system.
> > 
> > Sure, so we end up at vmalloc.  No worse, but simpler and much better if we
> > *can* do it.
> 
> If the likelihood is near zero, then you're wasting opportunities to do
> it better.  If we have compact per-cpu virtual areas then we can use
> large pages if we know we'll have large percpu areas.

You're right; we'd need that defrag wonderness people keep speculating about.

What finally convinced me is that the per-cpu chunks have to be at least the
size of the .data.percpu section (24k here).  7*num_possible_cpus() is even
worse.

Thanks,
Rusty.
