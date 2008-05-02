Return-Path: <linux-kernel-owner+w=401wt.eu-S932725AbYEBA3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbYEBA3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbYEBA3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:29:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757064AbYEBA3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:29:10 -0400
Date: Thu, 1 May 2008 17:28:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       hch@infradead.org, adobriyan@gmail.com, bunk@kernel.org
Subject: Re: [PATCH] add typecheck on irqsave and friends for correct flags
Message-Id: <20080501172810.fa39dad6.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0805011946290.12785@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805011946290.12785@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 19:51:18 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> There has been several areas in the kernel where an int has been used
> for flags in local_irq_save and friends instead of a long. This can
> cause some hard to debug problems on some architectures.
> 
> This patch adds a typecheck inside the irqsave and restore functions
> to flag these cases.

hm, not exactly a thing of beauty, but it could have been worse.


If we had implemeted these things properly, as

	unsigned long spin_lock_irqsave(spinlock_t *lock);

then we wouldn't be able to do this at all.

Oh well, thanks, I'll toss it in there.  Maybe this should go into
git-sched (aka git-omnibus)?

