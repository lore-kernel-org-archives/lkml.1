Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZE2B1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZE2B1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZE2B1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:27:22 -0400
Received: from ozlabs.org ([203.10.76.45]:47282 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZE2B1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:27:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [my_cpu_ptr 1/5] Introduce my_cpu_ptr()
Date: Fri, 29 May 2009 10:57:15 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
References: <20090527180635.008102701@gentwo.org> <200905281316.01923.rusty@rustcorp.com.au> <alpine.DEB.1.10.0905281153280.22354@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0905281153280.22354@gentwo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905291057.16286.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 01:29:31 am Christoph Lameter wrote:
> On Thu, 28 May 2009, Rusty Russell wrote:
> > On Thu, 28 May 2009 03:16:59 am cl@linux-foundation.org wrote:
> > > my_cpu_ptr(xx) = per_cpu_ptr(xx, smp_processor_id).
> >
> > I had this implemented earlier as as get_cpu_ptr()/__get_cpu_ptr(), to
> > match get_cpu_var() / __get_cpu_var().
>
> Have not seen it but it would be a bit confusing since
> we already have get_cpu* which must be paired with put_cpu*
> because of the refcount taking (get_cpu_var and get_cpu).
> get_cpu_ptr() would not have to be paired.

To clarify, get_cpu_ptr() would be paired with put_cpu_ptr().  __get_cpu_ptr() 
would be the "raw" one:

#define get_cpu_ptr(xx) per_cpu_ptr(xx, get_cpu())
#define __get_cpu_ptr(xx) per_cpu_ptr(xx, smp_processor_id())

> Better use a different name.
>
> 	my_cpu_ptr came from my_cpu_offset:

Yep, but that's not as widely exposed as get_cpu & get_cpu_var.

Cheers,
Rusty.
