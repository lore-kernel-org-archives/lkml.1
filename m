Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbYLAPi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbYLAPi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 10:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYLAPiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 10:38:18 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:38845 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLAPiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 10:38:17 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH -v3 6/8] fsnotify: add group priorities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org
In-Reply-To: <1228144857.11752.32.camel@localhost.localdomain>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172123.17115.31274.stgit@paris.rdu.redhat.com>
	 <1227803109.4454.1773.camel@twins>
	 <1228144857.11752.32.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 16:37:41 +0100
Message-Id: <1228145861.7070.20.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 10:20 -0500, Eric Paris wrote:
> 
> > I can
> > imagine for many groups and limit range a priority list might be better
> > suited.
> 
> talking about plist.h?  Since I don't allow 2 groups with the same
> priority I'd say a lot of the plist code would just be overhead (the
> prio list and the node list would be the same)
> 
> That's not a big deal since I don't really care about the add/remove
> code paths since they are all notification overhead/setup/teardown.  I
> would think that cleaner simpler code would probably be a better idea
> rather than performance for these areas especially since it looks like
> the speed critical parts of plists (list_for_each_entry) would be the
> exact same.
> 
> what I don't see is plists being protected by RCU and looking at
> plist_del it doesn't seem like it would be rcu safe.  RCU safe plists
> might be a good idea, but for now I think I should just do my own
> priority listing so I don't have to hold a lock while I walk the group
> list (that path is VERY hot)

plist.h provides a 2d structure, where you can iterate the priorities in
constant time no matter how many items of any one priority are enqueued.

Its basically a list of lists.

If as you say, you only have a hand full of items, there is no point.


