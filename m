Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbYARLFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbYARLFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYARLFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:05:42 -0500
Received: from twin.jikos.cz ([213.151.79.26]:51283 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbYARLFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:05:41 -0500
Date: Fri, 18 Jan 2008 12:04:55 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
In-Reply-To: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.64.0801181203240.15647@twin.jikos.cz>
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008, Steven Rostedt wrote:

> Thinking that it was locking up on my code I went looking down the wrong 
> path. I finally found (after examining an NMI dump) that the lockup 
> happened because printk was trying to wakeup the klogd daemon, which 
> caused a deadlock when the try_to_wakeup code tries to grab the runqueue 
> lock.

... which I have documented in the printk() comment's in commit 1492192b
:)

> Since printks are seldom called with interrupts disabled, we can
> hold off the waking of klogd if they are. We don't have access to
> the runqueue locks from printk, but those locks need interrupts
> disabled in order to be held.

If this patch is going to be merged, you should perhaps adjust the comment 
introduced by the above mentioned commit, so that it reflects the new 
behavior.

Thanks,

-- 
Jiri Kosina
