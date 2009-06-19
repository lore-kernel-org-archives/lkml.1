Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZFSW2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZFSW2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZFSW2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:28:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:35162 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbZFSW2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:28:33 -0400
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
 suspending
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, npiggin@suse.de,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20090619145913.GA1389@ucw.cz>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090619145913.GA1389@ucw.cz>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 08:27:29 +1000
Message-Id: <1245450449.16880.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 16:59 +0200, Pavel Machek wrote:
> 
> Ok... GFP_KERNEL allocations normally don't fail; now they
> will. Should we at least force access to atomic reserves in such case?

No. First, code that assumes GFP_KERNEL don't fail is stupid. Any
allocation should always be assumed to potentially fail.

Then, if you start failing allocations at boot time, then you aren't
going anywhere are you ?

Cheers,
Ben.


