Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbYKUOug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbYKUOug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYKUOu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:50:28 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:54520 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbYKUOu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:50:27 -0500
Date: Fri, 21 Nov 2008 08:49:29 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] cpu alloc cleanups and implementation improvement
In-Reply-To: <20081121163111.7107315e.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0811210842580.24965@quilx.com>
References: <200811172353.18356.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0811201030240.19948@quilx.com> <20081121163111.7107315e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, Stephen Rothwell wrote:

> > I would not mind if you would take over from here.
>
> So, should I remove the cpu_alloc tree from linux-next?

I think the cpu_alloc branch itself is fine because it only contains the
allocator and a single use case. The only point of disagreement at this
point is the uppercase / lowercase use. Currently its a separate API (its
not replacing allocpercpu) and therefore easy to merge.

The more invasive stuff is stage2 and the following which is not in next
yet. The way I envision to go forward is with a gradual transition to the
new APIs converting dynamic percpu users to use the new percpu operations
and functionality.

The whole thing becomes riskier if we directly replace all allocpercpu
users as proposed by Rusty.

Rusty, are you going to take this on?

