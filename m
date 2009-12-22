Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZLVPzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZLVPzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZLVPzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:55:42 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:48280 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZLVPzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:55:40 -0500
Date: Tue, 22 Dec 2009 09:54:26 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V8 11/16] Generic support for this_cpu_cmpxchg
In-Reply-To: <20091219144520.GA9134@Krystal>
Message-ID: <alpine.DEB.2.00.0912220950030.12163@router.home>
References: <20091218222617.384355422@quilx.com> <20091218222653.560936448@quilx.com> <20091219144520.GA9134@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Dec 2009, Mathieu Desnoyers wrote:

> I am a bit concerned about the "generic" version of this_cpu_cmpxchg.
> Given that what LTTng needs is basically an atomic, nmi-safe version of
> the primitive (on all architectures that have something close to a NMI),
> this means that it could not switch over to your primitives until we add
> the equivalent support we currently have with local_t to all
> architectures. The transition would be faster if we create an
> atomic_cpu_*() variant which would map to local_t operations in the
> initial version.
>
> Or maybe have I missed something in your patchset that address this ?

NMI safeness is not covered by this_cpu operations.

We could add nmi_safe_.... ops?

The atomic_cpu reference make me think that you want full (LOCK)
semantics? Then use the regular atomic ops?
