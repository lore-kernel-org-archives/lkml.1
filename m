Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbZFSXXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbZFSXXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZFSXXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:23:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58924 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZFSXXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:23:40 -0400
Date: Sat, 20 Jun 2009 01:23:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, npiggin@suse.de,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
	suspending
Message-ID: <20090619232336.GA2442@elf.ucw.cz>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI> <20090619145913.GA1389@ucw.cz> <1245450449.16880.10.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245450449.16880.10.camel@pasglop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-06-20 08:27:29, Benjamin Herrenschmidt wrote:
> On Fri, 2009-06-19 at 16:59 +0200, Pavel Machek wrote:
> > 
> > Ok... GFP_KERNEL allocations normally don't fail; now they
> > will. Should we at least force access to atomic reserves in such case?
> 
> No. First, code that assumes GFP_KERNEL don't fail is stupid. Any
> allocation should always be assumed to potentially fail.

Stupid, yes. Uncommon? Not sure.

> Then, if you start failing allocations at boot time, then you aren't
> going anywhere are you ?

Exactly. So boot code should have access to all the memory, right?
Setting some aside for GFP_ATOMIC does not make sense in that context.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
