Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZKEAnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZKEAnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZKEAnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:43:32 -0500
Received: from ozlabs.org ([203.10.76.45]:42110 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZKEAnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:43:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Correct nr_processes() when CPUs have been unplugged
Date: Thu, 5 Nov 2009 11:13:33 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Ian Campbell <Ian.Campbell@citrix.com>,
       Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1257243074.23110.779.camel@zakaz.uk.xensource.com> <20091103160734.GA21362@elte.hu> <alpine.DEB.1.10.0911031324380.32136@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0911031324380.32136@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911051113.33889.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 05:04:32 am Christoph Lameter wrote:
> On Tue, 3 Nov 2009, Ingo Molnar wrote:
> 
> > Sidenote: percpu areas currently are kept allocated on x86.
> 
> They must be kept allocated for all possible cpus. Arch code cannot decide
> to not allocate per cpu areas.
> 
> Search for "for_each_possible_cpu" in the source tree if you want more
> detail.

Yeah, handling onlining/offlining of cpus is a hassle for most code.

But I can see us wanting abstractions for counters which handle being per-cpu
or per-node and doing the folding etc. automagically.  It's best that this
be done by looking at all the existing users to see if there's a nice API
which would cover 90%.

Cheers,
Rusty.
