Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZBRGoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZBRGoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 01:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZBRGoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 01:44:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47078 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbZBRGoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 01:44:14 -0500
Message-ID: <499BAD54.3050108@zytor.com>
Date: Tue, 17 Feb 2009 22:40:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org> <200902170952.21063.rusty@rustcorp.com.au> <4999F693.5000105@zytor.com> <200902181455.11572.rusty@rustcorp.com.au>
In-Reply-To: <200902181455.11572.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>>>
>> num_possible_cpus() can be very large though, so in many cases the
>> likelihood of finding that many pages approach zero.  Furthermore,
>> num_possible_cpus() may be quite a bit larger than the actual number of
>> CPUs in the system.
> 
> Sure, so we end up at vmalloc.  No worse, but simpler and much better if we
> *can* do it.
> 

If the likelihood is near zero, then you're wasting opportunities to do
it better.  If we have compact per-cpu virtual areas then we can use
large pages if we know we'll have large percpu areas.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

