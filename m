Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZBWPj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZBWPj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZBWPjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:39:22 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51813 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbZBWPjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:39:21 -0500
Date: Mon, 23 Feb 2009 07:39:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223153917.GB6751@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220154619.GC6960@linux.vnet.ibm.com> <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com> <20090221014056.GU6960@linux.vnet.ibm.com> <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com> <20090221174703.GA6860@linux.vnet.ibm.com> <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com> <19f34abd0902211037w2293af16t561444d11cc834b8@mail.gmail.com> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com> <19f34abd0902230024g63aadad2jef16c97a9d792291@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0902230024g63aadad2jef16c97a9d792291@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 09:24:39AM +0100, Vegard Nossum wrote:
> 2009/2/23 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > Hello, Vegard,
> >
> > Could you please try out the following patch?  I am not 100% confident
> > of it on non-x86 architectures, nor during the time that non-boot CPUs
> > start up (though this patch should not break non-boot CPUs any more than
> > they might already be broken).
> 
> Hi!
> 
> This patch fixes it for me. Now I see the huge stream of call_rcu()s,
> followed by a huge stream of kfrees() (after the list traversal has
> completed).

Much better!!!  Thank you for checking this out!  To say nothing of all
your work finding and isolating the problem!

							Thanx, Paul
