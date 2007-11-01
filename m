Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbXKAF2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbXKAF2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 01:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXKAF1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 01:27:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53433
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752947AbXKAF1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 01:27:52 -0400
Date: Wed, 31 Oct 2007 22:27:51 -0700 (PDT)
Message-Id: <20071031.222751.25467933.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0710311820340.25687@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0710311810390.25643@schroedinger.engr.sgi.com>
	<20071031.181335.207429553.davem@davemloft.net>
	<Pine.LNX.4.64.0710311820340.25687@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Wed, 31 Oct 2007 18:21:02 -0700 (PDT)

> On Wed, 31 Oct 2007, David Miller wrote:
> 
> > From: Christoph Lameter <clameter@sgi.com>
> > Date: Wed, 31 Oct 2007 18:12:11 -0700 (PDT)
> > 
> > > On Wed, 31 Oct 2007, David Miller wrote:
> > > 
> > > > All I can do now is bisect and then try to figure out what about the
> > > > guilty change might cause the problem.
> > > 
> > > Reverting the 7th patch should avoid using the sparc register that caches 
> > > the per cpu area offset? (I though so, does it?)
> > 
> > Yes, that's right, %g5 holds the local cpu's per-cpu offset.
> 
> And if I add the address of a percpu variable then I get to the variable 
> for this cpu right?

Right.

I bisected the crash down to:

	[PATCH] newallocpercpu
