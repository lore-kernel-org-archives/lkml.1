Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbZG2BtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbZG2BtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZG2Bs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:48:59 -0400
Received: from ozlabs.org ([203.10.76.45]:44989 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZG2Bs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:48:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Rientjes <rientjes@google.com>
Subject: Re: [regression] sched_getaffinity fails with EINVAL in 2.6.31-rc4
Date: Wed, 29 Jul 2009 11:18:53 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Gregory Haskins <gregory.haskins@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
References: <4A6DE0DC.2070207@gmail.com> <alpine.DEB.2.00.0907271108350.8408@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0907271108350.8408@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907291118.53912.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 03:42:15 am David Rientjes wrote:
> On Mon, 27 Jul 2009, Gregory Haskins wrote:
> 
> > I am not sure when this started, but noticed that sched_getaffinity is
> > not working in -rc4.
> > 
> > [pid  6254] sched_getaffinity(0, 128, 0x7f80586b1fe0) = -1 EINVAL
> > (Invalid argument)
> > 
> > Here is a simple program for reproduction:
> > 
> > #include <sched.h>
> > 
> > int main(void)
> > {
> > 	cpu_set_t mask;
> > 	int ret;
> > 
> > 	ret = sched_getaffinity(0, sizeof(mask), &mask);
> > 	if (ret < 0)
> > 		perror("getaffinity");
> > 
> > 	return ret;
> > }
> > 
> > If I get time, I will bisect this later today.
> > 
> 
> It's most likely due to the cpumask changes.  I don't know what cpu_set_t 
> is, but it's probably smaller than CONFIG_NR_CPUS rounded up to a multiple 
> of sizeof(long).

It's simply that you finally ran this on a kernel which had
CONFIG_NR_CPUS > 1024.

I argued strongly against the set and getaffinity interfaces when they were
introduced; they can't be used in general without a loop (enlarge cpu_set,
retry).

Cheers,
Rusty.
