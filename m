Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYJHCsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYJHCsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYJHCsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:48:15 -0400
Received: from mail.suse.de ([195.135.220.2]:37441 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbYJHCsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:48:15 -0400
Date: Wed, 8 Oct 2008 04:48:13 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-netdev@vger.kernel.org, paulmck@us.ibm.com
Subject: Re: [patch][rfc] ddds: "dynamic dynamic data structure" algorithm, for adaptive dcache hash table sizing
Message-ID: <20081008024813.GC6499@wotan.suse.de>
References: <20081007064834.GA5959@wotan.suse.de> <20081007.140825.40261432.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007.140825.40261432.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 02:08:25PM -0700, David Miller wrote:
> From: Nick Piggin <npiggin@suse.de>
> Date: Tue, 7 Oct 2008 08:48:34 +0200
> 
> > I'm cc'ing netdev because Dave did express some interest in using this for
> > some networking hashes, and network guys in general are pretty cluey when it
> > comes to hashes and such ;)
> 
> Interesting stuff.
> 
> Paul, many months ago, forwarded to me a some work done by Josh
> Triplett called "rcuhashbash" which had similar objectives.  He did
> post it to linux-kernel, and perhaps even your ideas are inspired by
> his work, I don't know. :-)

Hmm yes I did see that. It's not too similar, as it focuses on re-keying
an existing element into the same hash table. ddds can't do that kind of
thing (the underlying data structure isn't visible to the algorithm, so
it can't exactly modify data structures in-place), although in another
sense it is more general because the transfer function could transfer
items into another hash table and re-key them as it goes (if it did that,
it could probably use Josh's "atomic" re-keying algorithm too).

But largely it does seem like they are orthogonal (if I'm reading
rcuhashbash correctly).

