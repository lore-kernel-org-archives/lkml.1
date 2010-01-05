Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568Ab0AEWfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0AEWfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316Ab0AEWfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:35:30 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46722 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab0AEWf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:35:29 -0500
Date: Tue, 5 Jan 2010 16:34:45 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 0/4] Remove local_t
In-Reply-To: <20100105222351.GA29675@Krystal>
Message-ID: <alpine.DEB.2.00.1001051629550.9108@router.home>
References: <20100105220417.400092933@quilx.com> <20100105222351.GA29675@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Mathieu Desnoyers wrote:

> Yes, removing the local_t type could make sense. However, local_t maps
> to a volatile long, not just "long". Secondly, I am concerned about the
> fact that the patch you propose:

Volatile is discouraged as far as I can tell.

> - does not create the primitives I use in lttng
> - only deals with x8

As I said its an RFC. This provides all the functionality you need
through. The rest is sugar coating.

> In lttng (which is out of tree, but widely used), I need the equivalent
> of:
>
> local_read
> local_set
> local_add
> local_cmpxchg
> local_add_return
> local_inc

Please read the patch! This is all provided. add_local_return in the RFC
provides what is needed to replace local_add, local_inc. We can add these
explicitly.

local_cmpxchg replacement is already in there in the form of
cmpxchg_local().

> The approach of just doing the x86 implementation and leaving all the
> other architectures "for later" with a slow/non atomic generic fallback
> is, imho, a no-go, given that some people (myself, actually) already
> took the time to go through all the kernel architectures to create the
> optimized local.h headers. Basically, you are destroying all that work,
> asking for it to be done all over again.

AS I said this is an RFC. I can easily generate all these things from the
existing local.hs for the architectures.

> I therefore argue that we should keep local.h as-is as long as the
> replacement lacks the wide architecture support and primitive variety
> found in local.h.

Cool down and please review the patch.


