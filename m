Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZIIOGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZIIOGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZIIOGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:06:07 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:32925 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752528AbZIIOGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:06:05 -0400
Date: Wed, 9 Sep 2009 10:04:20 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix slab_pad_check()
In-Reply-To: <20090908225937.GO6753@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0909091002440.28070@V090114053VZO-1>
References: <4A9FDA72.8060001@gmail.com> <alpine.DEB.1.10.0909031414310.29881@V090114053VZO-1> <4AA00400.1030005@gmail.com> <alpine.DEB.1.10.0909031731540.24199@V090114053VZO-1> <20090903231757.GP6761@linux.vnet.ibm.com> <alpine.DEB.1.10.0909041140040.9781@V090114053VZO-1>
 <20090904204335.GG6751@linux.vnet.ibm.com> <alpine.DEB.1.10.0909081555410.26382@V090114053VZO-1> <20090908222036.GM6753@linux.vnet.ibm.com> <alpine.DEB.1.10.0909081839090.7733@V090114053VZO-1> <20090908225937.GO6753@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Paul E. McKenney wrote:

> > No direct request but I have seen the network developers discover these
> > features and their caching benefits over the last year. It is likely that
> > they will try to push it into more components of the net subsystem.
>
> So if they push it far enough, they might well decide that they need
> a SLAB_DESTROY_BY_RCU_BH, for example.  Looks like seven bits left,
> so unless I am missing something, should not be a huge problem should
> this need arise.

I'd rather have the call_rcu in the slabs replaced by a function that
can be set by the user. Then we can remove all rcu barriers from the code
and the slabs could be used with any type of rcu functionality.

