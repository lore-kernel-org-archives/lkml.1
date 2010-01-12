Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642Ab0ALBJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0ALBJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593Ab0ALBJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:09:53 -0500
Received: from ozlabs.org ([203.10.76.45]:48342 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab0ALBJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:09:53 -0500
Date: Tue, 12 Jan 2010 12:07:21 +1100
From: Anton Blanchard <anton@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       David Rientjes <rientjes@google.com>
Subject: Re: [patch 0/6] cpumask_of_node() should handle -1 as a node
Message-ID: <20100112010721.GC12666@kryten>
References: <20100106045509.245662398@samba.org>
 <20100111141136.0ee352b3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111141136.0ee352b3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

> > A number of places in the kernel use cpumask_of_node(-1), but most arch
> > NUMA implementations are broken. The following patches fix this.
> 
> So..  what's happening here?  Nobody has applied the patches anywhere,
> you later said "the scheduler oopses in a number of places with
> CPUMASK_OFFSTACK and sparse node ids" and mention of a -stable backport
> was mentioned.

That scheduler issue doesn't appear in mainline as no one is allocating sparse
node IDs yet.

There is still the opportunity for an Oops with CPUMASK_OFFSTACK and
/sys/.../local_cpus and even with CPUMASK_OFFSTACK disabled it will return
random data.

Ralph has picked up the mips bit, Ben is sucking in the powerpc bit.
Davem has acked the sparc bit. I'll roll up a -stable patch once they
hit.

No answer from alpha and ia64.

Anton
