Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZJFKdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZJFKdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbZJFKdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:33:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666AbZJFKda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:33:30 -0400
Date: Tue, 6 Oct 2009 12:33:00 +0200
From: Gleb Natapov <gleb@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH][RFC] add MAP_UNLOCKED mmap flag
Message-ID: <20091006103300.GI9832@redhat.com>
References: <20091006190938.126F.A69D9226@jp.fujitsu.com>
 <20091006102136.GH9832@redhat.com>
 <20091006192454.1272.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006192454.1272.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 07:27:56PM +0900, KOSAKI Motohiro wrote:
> > On Tue, Oct 06, 2009 at 07:11:06PM +0900, KOSAKI Motohiro wrote:
> > > Hi
> > > 
> > > > If application does mlockall(MCL_FUTURE) it is no longer possible to
> > > > mmap file bigger than main memory or allocate big area of anonymous
> > > > memory. Sometimes it is desirable to lock everything related to program
> > > > execution into memory, but still be able to mmap big file or allocate
> > > > huge amount of memory and allow OS to swap them on demand. MAP_UNLOCKED
> > > > allows to do that.
> > > > 
> > > > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > > 
> > > Why don't you use explicit munlock()?
> > Because mmap will fail before I'll have a chance to run munlock on it.
> > Actually when I run my process inside memory limited container host dies
> > (I suppose trashing, but haven't checked).
> > 
> > > Plus, Can you please elabrate which workload nedd this feature?
> > > 
> > I wanted to run kvm with qemu process locked in memory, but guest memory
> > unlocked. And guest memory is bigger then host memory in the case I am
> > testing. I found out that it is impossible currently.
> 
> 1. process creation (qemu)
> 2. load all library
Can't control this if program has plugging. Not qemu case
though.

> 3. mlockall(MCL_CURRENT)
> 4. load guest OS
And what about all other allocations qemu does during its life time? Not
all of them will be small enough to be from brk area.

> 
> is impossible? why?
> 
Because what you are proposing is not the same as mlockall(MCL_CURRENT|MCL_FUTURE);
You essentially say that MCL_FUTURE is not needed.

--
			Gleb.
