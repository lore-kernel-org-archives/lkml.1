Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbZIDTZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbZIDTZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbZIDTZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:25:46 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:36057 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757165AbZIDTZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:25:45 -0400
Date: Fri, 4 Sep 2009 11:42:17 -0400 (EDT)
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
In-Reply-To: <20090903231757.GP6761@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0909041140040.9781@V090114053VZO-1>
References: <4A9F1620.2080105@gmail.com> <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com> <4A9F7283.1090306@gmail.com> <alpine.DEB.1.10.0909031244230.27903@V090114053VZO-1> <4A9FCDC6.3060003@gmail.com> <alpine.DEB.1.10.0909031335430.29881@V090114053VZO-1>
 <4A9FDA72.8060001@gmail.com> <alpine.DEB.1.10.0909031414310.29881@V090114053VZO-1> <4AA00400.1030005@gmail.com> <alpine.DEB.1.10.0909031731540.24199@V090114053VZO-1> <20090903231757.GP6761@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009, Paul E. McKenney wrote:

> If it were the user of the slab who was invoking some variant of
> call_rcu(), then I would agree with you.

The user already has to deal with it as explained by Eric.

> However, call_rcu() is instead being invoked by the slab itself in the
> case of SLAB_DESTROY_BY_RCU, so that there is no variation in usage.
> Requiring that the user call rcu_barrier() is asking for subtle bugs.
> Therefore, the best approach is to have kmem_cache_destroy() handle
> the RCU cleanup, given that this cleanup is for actions taken by
> kmem_cache_free(), not by the user.

The user already has to properly handle barriers and rcu logic in order to
use objects handled with RCU properly. Moreover the user even has to check
that the object is not suddenly checked under it. Its already complex.

