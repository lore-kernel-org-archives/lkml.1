Return-Path: <linux-kernel-owner+w=401wt.eu-S1765220AbZFLVrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765220AbZFLVrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934268AbZFLVr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:47:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:42093 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934273AbZFLVr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:47:28 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       npiggin@suse.de, yinghai@kernel.org
In-Reply-To: <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 07:46:03 +1000
Message-Id: <1244843163.23936.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Adds code to hot code path.

A single mask which should be mostly in the noise...

> The allocators mask flags passed to the page allocator through
> GFP_RECLAIM_MASK|GFP_CONSTRAINT_MASK. This is done outside of the critical
> code paths.
> 
> The might_sleep issues may be fixed by adding another check to
> __might_sleep().

That is not enough because slab and slub explicitely re-enable
interrupts when __GFP_WAIT is set, which is the problem we need to solve
in the first place, so we need to do the masking there.

Cheers,
Ben.


