Return-Path: <linux-kernel-owner+w=401wt.eu-S1030843AbXDPXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030843AbXDPXZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 19:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031025AbXDPXZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 19:25:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:48854 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030843AbXDPXZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 19:25:23 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Tue, 17 Apr 2007 09:24:47 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17956.1471.150238.216776@notabene.brown>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: message from Theodore Tso on Monday April 16
References: <20070408184129.GA20871@lazybastard.org>
	<17947.65165.569482.976343@notabene.brown>
	<20070411144252.GB17778@thunk.org>
	<17949.25061.739035.688232@notabene.brown>
	<20070411232224.GF17778@thunk.org>
	<17949.36737.701327.104172@notabene.brown>
	<20070412023712.GA8175@lazybastard.org>
	<17949.51797.386833.917451@notabene.brown>
	<20070412122116.GD28148@thunk.org>
	<17955.5453.164637.970405@notabene.brown>
	<20070416110702.GF27533@thunk.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday April 16, tytso@mit.edu wrote:
> 
> The challenge is making it be stable across inserts/deletes, never
> mind reboots.  And it's not a "little bit of cacheing"; in order to be
> correct we would have to cache *forever*, since at least in theory an
> NFS client could hold on to a cookie for an arbitrarily long period of
> time (weeks, months, years, decades), yes?

Yes.  But I think we've already establish that the on-disk structure
chosen by ext3/htree is not able to perfectly support NFS (which is a
pity given that it was written for Linux and Linux is thought to
support NFS).  Our goal is to find the best mapping possible and,
where caching can improve stability for real-world uses, use caching
to help stabilise that mapping.

> 
> You're welcome to try, but I suspect it won't take long before you'll
> see why I'm asserting that a directory fd cache in nfsd is *way* less
> work.  :-)

You have provided some very helpful insights into how ext3/htree
currently works - thanks for that.
I will definitely make a closer inspection of the code and so how
possible it is to realise by ideas.  I'll let you know how I go.

NeilBrown
