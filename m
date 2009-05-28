Return-Path: <linux-kernel-owner+w=401wt.eu-S1763335AbZE1QAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763335AbZE1QAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZE1P74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:59:56 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45225 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753468AbZE1P7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:59:55 -0400
Date: Thu, 28 May 2009 11:59:31 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [my_cpu_ptr 1/5] Introduce my_cpu_ptr()
In-Reply-To: <200905281316.01923.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0905281153280.22354@gentwo.org>
References: <20090527180635.008102701@gentwo.org> <20090527180714.834691580@gentwo.org> <200905281316.01923.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Rusty Russell wrote:

> On Thu, 28 May 2009 03:16:59 am cl@linux-foundation.org wrote:
> > my_cpu_ptr(xx) = per_cpu_ptr(xx, smp_processor_id).
>
> I had this implemented earlier as as get_cpu_ptr()/__get_cpu_ptr(), to match
> get_cpu_var() / __get_cpu_var().

Have not seen it but it would be a bit confusing since
we already have get_cpu* which must be paired with put_cpu*
because of the refcount taking (get_cpu_var and get_cpu).
get_cpu_ptr() would not have to be paired.

Better use a different name.

	my_cpu_ptr came from my_cpu_offset:

#define my_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
#define __my_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
