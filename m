Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbYIRRnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbYIRRnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYIRRni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:43:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57117 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbYIRRnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:43:37 -0400
Date: Thu, 18 Sep 2008 10:15:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, manfred@colorfullife.com
Subject: Re: [RFC PATCH] rcu: introduce kfree_rcu()
Message-ID: <20080918171542.GC6605@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48D1D694.9010802@cn.fujitsu.com> <20080918064406.GC6397@linux.vnet.ibm.com> <48D21875.7030605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D21875.7030605@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 04:59:33PM +0800, Lai Jiangshan wrote:

[ . . . ]

> 1) unloadable modules:
>    A) use my_struct_release_rcu():
>       when we unload this modules, we need call rcu_barrier() to wait
>       all my_struct_release_rcu() had called.
>    B) use kfree_rcu():
>       if all trivial callback are removed and kfree_rcu() are used instead,
>       we do not need to wait anything. just quick finish unloading.

OK, so the trick is that the module -never- uses call_rcu()
directly, instead using -only- kfree_rcu(), along perhaps also with
synchronize_rcu().  Because kfree_rcu() does not reference module text,
you then don't need to wait at all.  Good point!

							Thanx, Paul
