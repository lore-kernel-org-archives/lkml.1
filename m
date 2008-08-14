Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYHNNZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYHNNZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYHNNZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:25:08 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60659 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752171AbYHNNZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:25:07 -0400
Date: Thu, 14 Aug 2008 09:24:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: tvrtko.ursulin@sophos.com
Cc: alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080814132455.GE6469@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, tvrtko.ursulin@sophos.com,
	alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
	Arjan van de Ven <arjan@infradead.org>,
	Eric Paris <eparis@redhat.com>, hch@infradead.org,
	linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
	malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
	viro@ZenIV.linux.org.uk
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814093103.6CD102FE8B4@pmx1.sophos.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 10:30:56AM +0100, tvrtko.ursulin@sophos.com wrote:
> The thing is the idea never was for clean-dirty "database" to be 
> persistent but to have the same lifetime as the inode (in memory one). And 
> once the cache/database gets invalidated re-scanning happens on-demand so 
> the 5TB problem does not exist. Concerns about multiple clients where 
> every has a different versioning scheme are also not relevant with the 
> proposed versioning scheme (see my reply to Arjan).

So in essence, what I hear you saying is that all AV products want to
work in a mode where the moment the inode falls out of the inode
cache, and we lose the "clean" bit, when the inode is brought back
into the cache, it will be scanned again.  That is, the "clean" bit is
never persistent, and never needs to be stored in memory.

That seems fair; if it turns out there is an AV product that wants to
optimize this a bit further, as long as we provide a persistent inode
version/generation number, they can always do their own persistent
database in userspace.

							- Ted
