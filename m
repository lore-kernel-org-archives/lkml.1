Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbYHNNtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbYHNNtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYHNNsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:48:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYHNNsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:48:50 -0400
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
From: Eric Paris <eparis@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
In-Reply-To: <20080814132455.GE6469@mit.edu>
References: <20080813192922.GI8232@mit.edu>
	 <20080814093103.6CD102FE8B4@pmx1.sophos.com>
	 <20080814132455.GE6469@mit.edu>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 09:48:33 -0400
Message-Id: <1218721713.3540.125.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 09:24 -0400, Theodore Tso wrote:
> On Thu, Aug 14, 2008 at 10:30:56AM +0100, tvrtko.ursulin@sophos.com wrote:
> > The thing is the idea never was for clean-dirty "database" to be 
> > persistent but to have the same lifetime as the inode (in memory one). And 
> > once the cache/database gets invalidated re-scanning happens on-demand so 
> > the 5TB problem does not exist. Concerns about multiple clients where 
> > every has a different versioning scheme are also not relevant with the 
> > proposed versioning scheme (see my reply to Arjan).
> 
> So in essence, what I hear you saying is that all AV products want to
> work in a mode where the moment the inode falls out of the inode
> cache, and we lose the "clean" bit, when the inode is brought back
> into the cache, it will be scanned again.  That is, the "clean" bit is
> never persistent, and never needs to be stored in memory.

There needs to be a way to say that an inode in cache needs to be
rescanned.  3 states this flag can be.  Clean, Dirty, Infected.  The
current talpa solution involves a global monotomically increasing
counter every time you change virus defs or make some "interesting"
change.  If global == inode flag we are clean.  If global == negative
inode flag we are infected.  if global > inode flag we are dirty and
need a scan.

> That seems fair; if it turns out there is an AV product that wants to
> optimize this a bit further, as long as we provide a persistent inode
> version/generation number, they can always do their own persistent
> database in userspace.

exporting i_version might be useful for better userspace caching,
although I've yet to see any reasonable description of how a userspace
database can map between data on disk and what they have in userspace.
How can a userspace process, given 2 file descriptors know they are
actually the same thing on disk?

