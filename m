Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbXIPURG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbXIPURG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXIPUQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:16:54 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39758 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbXIPUQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:16:53 -0400
Date: Sun, 16 Sep 2007 22:16:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH] 9p: add readahead support for loose mode
Message-ID: <20070916221606.065e449f@lappy>
In-Reply-To: <20070915034126.cd2c2073.akpm@linux-foundation.org>
References: <11897857601214-git-send-email-ericvh@gmail.com>
	<20070915034126.cd2c2073.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007 03:41:26 -0700 Andrew Morton
<akpm@linux-foundation.org> wrote:

> eww, kmap.  Large amounts of them, apparently.
> 
> Be aware that kmap is a) slow and b) deadlockable.  The latter happens when
> multiple tasks want to take more than one kmap simultaneously: they all
> wait for someone else to release one.  Your code here seems especially
> vulnerable to this.
> 
> Nick had a kmap-speedup patchset a while back which addressed a) but I
> don't know if it addressed the deadlock.  But that patch seemed to die.

That would've been me.

What I did to address b) is to pre-allocate each kmap user a second
kmap slot. Of course this isn't water-tight either.

These patches are part of -rt, I could respin against mainline if there
is interest.
