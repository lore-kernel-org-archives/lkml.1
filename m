Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbXFBAQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbXFBAQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXFBAQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:16:38 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754141AbXFBAQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:16:38 -0400
Date: Fri, 1 Jun 2007 17:16:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601171612.8194394a.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706011653290.3957@woody.linux-foundation.org>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<466081DE.70205@goop.org>
	<Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
	<20070601135900.ec44b1aa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
	<20070601151649.bb23c6f9.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
	<20070601153328.1118ccaf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
	<alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
	<Pine.LNX.4.64.0706011617330.9781@schroedinger.engr.sgi.com>
	<alpine.LFD.0.98.0706011638360.3957@woody.linux-foundation.org>
	<Pine.LNX.4.64.0706011642530.9992@schroedinger.engr.sgi.com>
	<alpine.LFD.0.98.0706011653290.3957@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 16:57:20 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Andrew, want to take this patch to -mm to see if it triggers anything?

spose so.

I think it'd be better if we kept the WARN_ON_ONCE(size == 0) in there,
because it is exposing some coding warts.  But we should turn it off for
2.6.22 and make it conditional on CONFIG_DEVEL_KERNEL (or whatever it will
be called) later.

The BADPTR thing is a little worrying because it will make
previously-working-by-luck code go oops.  I guess we can live with that.

So we end up with the BADPTR code enabled even in production kernels, in
which case your ((unsigned long)x <= 16) trick is worth doing.

