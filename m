Return-Path: <linux-kernel-owner+w=401wt.eu-S1761197AbZFOPLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197AbZFOPLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbZFOPLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:11:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60260 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbZFOPK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:10:59 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
In-Reply-To: <alpine.DEB.1.10.0906151101580.23995@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
	 <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906151051240.19931@gentwo.org>
	 <1245077891.23207.48.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906151101580.23995@gentwo.org>
Date: Mon, 15 Jun 2009 18:11:01 +0300
Message-Id: <1245078661.23207.50.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, 2009-06-15 at 11:05 -0400, Christoph Lameter wrote:
> On Mon, 15 Jun 2009, Pekka Enberg wrote:
> 
> > > Dont do it there. Only modify the slow path.
> > >
> > > Look at __might_sleep(). It already has an exception for system_state !=
> > > RUNNING. If it still triggers then add to the condition there.
> >
> > But does this matter? When the debugging options are turned off, there
> > are no users for "real_gfp" and thus GCC optimizes everything away. For
> > debugging configs, the extra cacheline load doesn't matter, does it?
> 
> It cleaner to have the fastpath as small as possible. Having unused
> variables in there is a bit confusing.

OK, I can clean this up, no problem.

On Mon, 2009-06-15 at 11:05 -0400, Christoph Lameter wrote:
> Also the path is performance critical. That may not matter for the debug
> case in some sitiations. But there are people that keep the debugging
> options on. Better to limit the impact as much as possible.
> 
> And the "extra cacheline load does not matter" reasoning can only be
> applied so many times. An extra cacheline load increases the cache foot
> print of the fast path after all.

The point here is that the actual debugging hooks do a whole lot more
than cacheline load + alu op even in the "fastpath" case (if such a
thing exists for those).

		Pekka

