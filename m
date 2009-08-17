Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbZHQN43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbZHQN43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZHQN42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:56:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbZHQN40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:56:26 -0400
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
From: James Bottomley <James.Bottomley@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>,
       Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
       Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
In-Reply-To: <20090816165943.GA26983@infradead.org>
References: <4A85E0DC.9040101@rtr.ca>
	 <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>
	 <20090814234539.GE27148@parisc-linux.org>
	 <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>
	 <1250341176.4159.2.camel@mulgrave.site> <4A86B69C.7090001@rtr.ca>
	 <1250344518.4159.4.camel@mulgrave.site>
	 <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>
	 <20090816083434.2ce69859@infradead.org>
	 <1250437927.3856.119.camel@mulgrave.site>
	 <20090816165943.GA26983@infradead.org>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 08:56:12 -0500
Message-Id: <1250517372.3844.3.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-16 at 12:59 -0400, Christoph Hellwig wrote:
> On Sun, Aug 16, 2009 at 10:52:07AM -0500, James Bottomley wrote:
> > However, the enterprise has been doing UNMAP for a while, so we can draw
> > inferences from them since the SSD FTL will operate similarly.  For
> > them, UNMAP is the same cost in terms of time regardless of the number
> > of extents.  The reason is that it's moving the blocks from the global
> > in use list to the global free list.  Part of the problem is that this
> > involves locking and quiescing, so UNMAP ends up being quite expensive
> > to the array but constant in terms of cost (hence they want as few
> > unmaps for as many sectors as possible).
> 
> How are they doing the unmaps?  Using something similar to Mark's wiper
> script and using SG_IO?  Because right now we do not actually implement
> UNMAP support in the kernel.  I'd really love to test the XFS batched
> discard support with a real UNMAP implementation.

You mean how is the array vendor testing their implementation?  Using
SG_IO ... without any filesystem, I believe.

The testing was initially done to see if the initial maximal discard
proposal from LSF09 was a viable approach (which it wasn't given the
time taken to UNMAP).

James


