Return-Path: <linux-kernel-owner+w=401wt.eu-S965860AbXD1Q3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965860AbXD1Q3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965881AbXD1Q3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:29:48 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965860AbXD1Q3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:29:47 -0400
Date: Sat, 28 Apr 2007 09:28:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Back to the future.
In-Reply-To: <20070428085000.GA3293@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704280926140.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280300.22604.rjw@sisk.pl>
 <alpine.LFD.0.98.0704271801020.9964@woody.linux-foundation.org>
 <200704280344.49674.rjw@sisk.pl> <20070428085000.GA3293@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Pavel Machek wrote:
> 
> We do not want kernel threads running:
> 
> a) they may hold some locks and deadlock suspend
> 
> b) they may do some writes to disk, leading to corruption

You're really just making both of those up.

If a kernel thread holds a lock and deadlocks suspend, that would deadlock 
anythign else _too_. Suspend isn't *that* special. Everything it does are 
things other people do too.

And no, kernel threads do not write to disk on their own. Name one. They 
help *others* write to disk, but those disk writes need to happen.

The freezer has *caused* those deadlocks (eg by stopping threads that were 
needed for the suspend writeouts to succeed!), not solved them.

So stop making these totally bogus arguments up.

			Linus
