Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZAJV2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZAJV2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZAJV2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:28:12 -0500
Received: from thunk.org ([69.25.196.29]:37050 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbZAJV2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:28:11 -0500
Date: Sat, 10 Jan 2009 16:27:40 -0500
From: Theodore Tso <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090110212740.GE31579@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Andi Kleen <andi@firstfloor.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <1231584446.3685.21.camel@johannes> <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com> <1231587428.3803.0.camel@johannes> <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com> <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes> <87fxjrgd9s.fsf@basil.nowhere.org> <20090110202315.GE20611@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090110202315.GE20611@logfs.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 09:23:16PM +0100, Jörn Engel wrote:
> 
> Key difference is the number of cachelines you need to find a particular
> entry.  rbtrees have a fanout of sqrt(3), so for a million elements (to
> pick a random example) you need about 25 cachelines with rbtrees and
> about 5-16 with btrees.  Closer to 5 if keys and pointers are small and
> cachelines are large, closer to 16 if keys and pointers are large and
> cachelines are small.

Three questions....  is the number of cachelines in use going to make a
measurable difference for your use case in the filesystem?  If the
operation is going to involve disk access, trying to optimize for to
improve cacheline utilization may not be the higher priority thing to
worry about.

If you have a million elements, and assuming each element is but 4
bytes (which seems unlikely; very likely you'd be indexing at least
8-12 bytes of data, right?) we're talking about 4 megabytes of
non-swappable kernel memory.  Is that likely to be happen in your use
case?

Finally, are b+tree so much better than rbtrees that it would be
worthwhile to just *replace* rbtrees with b+trees?  Or is the problem
the overhead issue if the number of entries in an rbtree is relatively
small?

Regards,

						- Ted
