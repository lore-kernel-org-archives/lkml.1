Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbZAJWY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbZAJWY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZAJWYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:24:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbZAJWYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:24:47 -0500
Date: Sat, 10 Jan 2009 14:23:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-Id: <20090110142330.295a8847.akpm@linux-foundation.org>
In-Reply-To: <20090110220135.GF20611@logfs.org>
References: <1231584446.3685.21.camel@johannes>
	<2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com>
	<1231587428.3803.0.camel@johannes>
	<2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com>
	<20090110183921.GD20611@logfs.org>
	<1231613042.3706.16.camel@johannes>
	<87fxjrgd9s.fsf@basil.nowhere.org>
	<20090110202315.GE20611@logfs.org>
	<20090110212740.GE31579@mit.edu>
	<20090110220135.GF20611@logfs.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009 23:01:35 +0100 J__rn Engel <joern@logfs.org> wrote:

> One key difference is that rbtrees maintain the tree within objects and
> btrees maintain the tree externally.  So btrees have to allocate memory
> on insertion, where rbtrees have the necessary memory as part of the
> object.

This is a major disadvantage of the btrees.

See all the hoops we ended up jumping through with things like
radix_tree_preload() and idr_pre_get().

The IDR code there wasn't very well designed and still has holes.  The
radix-tree code afaik is solid, but look at all the stuff it does!

>  With mempools the memory allocation should be reasonably safe,
> so maybe this is a bit of a red herring now.

No, mempools won't help, particularly if items are being added from
atomic contexts.

This is a major major shortcoming which greatly limits the usefulness
of btrees and which greatly reduces the chances of anyone migrating any
rbtree users over to btrees.
