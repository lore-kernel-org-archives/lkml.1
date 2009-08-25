Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZHYMOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZHYMOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 08:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZHYMOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 08:14:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43353 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbZHYMOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 08:14:04 -0400
Date: Tue, 25 Aug 2009 14:13:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Shanab <jshanab@earthlink.net>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz
Subject: Re: Starting a grad project that may change kernel VFS. Early
	research
Message-ID: <20090825121356.GF1341@ucw.cz>
References: <4A93284C.7060604@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A93284C.7060604@earthlink.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2) Second Question. The two part idea.
>     I was thinking that a good way to handle this is that it starts with
> a file change in a directory. The directory entry contains a sum already
> for itself and all the subdirs and an adjustment is made immediately to
> that, it should be in the cache. Then we queue up the change to be sent
> to the parent(s?). These queued up events should be a low priority at a
> more human time like 1 second. If a large number of changes come to a
> directory, multiple adjustments hit the queue with the same (directory
> name, inode #?) and early ones are thrown out. So levels above would see
> at most a 1 per second low priority update.
> 
>     So when you issue a 'du -sh' or use anything that uses stat like
> filelight, it can get the size of all the subdirs without actually
> recursing through them, they have been built up over time.

I'd suggest you look at jack's recursive mtime idea, and then
implement your features on top of that, in userland.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
