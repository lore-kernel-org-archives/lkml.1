Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbZFOOnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbZFOOnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZFOOni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:43:38 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46646 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751528AbZFOOnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:43:37 -0400
Date: Mon, 15 Jun 2009 10:43:09 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <1244843163.23936.2.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0906151042460.19931@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>  <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>  <alpine.DEB.1.10.0906121317140.23840@gentwo.org> <1244843163.23936.2.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009, Benjamin Herrenschmidt wrote:

>
> > Adds code to hot code path.
>
> A single mask which should be mostly in the noise...
>
> > The allocators mask flags passed to the page allocator through
> > GFP_RECLAIM_MASK|GFP_CONSTRAINT_MASK. This is done outside of the critical
> > code paths.
> >
> > The might_sleep issues may be fixed by adding another check to
> > __might_sleep().
>
> That is not enough because slab and slub explicitely re-enable
> interrupts when __GFP_WAIT is set, which is the problem we need to solve
> in the first place, so we need to do the masking there.

If you mask the bit then both wont reenable interrupts.

