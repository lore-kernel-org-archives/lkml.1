Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbXEOTX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbXEOTX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbXEOTXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:23:51 -0400
Received: from lazybastard.de ([212.112.238.170]:33379 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbXEOTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:23:50 -0400
Date: Tue, 15 May 2007 21:19:26 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: John Stoffel <john@stoffel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070515191926.GB1220@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <17994.1241.436841.681216@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17994.1241.436841.681216@stoffel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 15:07:05 -0400, John Stoffel wrote:
> 
> I've been semi watching this, and the only comment I really can give
> is that I hate the name.  To me, logfs implies a filesystem for
> logging purposes, not for Flash hardware with wear leveling issues to
> be taken into account.

Yeah, well, ...

Two years ago when I started all this, I was looking for a good name.
All I could come up with sounded stupid, so I picked "LogFS" as a code
name.  As soon as I find a better name, the code name should get
replaced.

By now I still don't have anything better.  All alternatives that were
proposed are just as bad - with the added disadvantage of being new and
not established yet.  My hope of ever finding a better name is nearly
zero.

> Also, having scanned through the code, I find the name "cookie" using
> in logfs_inode(), logfs_iput(), logfs_iget() to be badly named.  It
> should really be something like *cached_inode, which would seem to
> give more natural semantics of
> 
> 	if (cached_inode)
> 		do_cached_inode_ops(...)
> 	else
> 		do_inode_ops(...)

Half-agreed.  For callers, the name "cookie" makes sense.  It is a
transparent thing they should not tough and hand back unchanged.  For
logfs_iget() and logfs_iput() something like "is_cached" would be
better.

Will change.

Jörn

-- 
Linux [...] existed just for discussion between people who wanted
to show off how geeky they were.
-- Rob Enderle
