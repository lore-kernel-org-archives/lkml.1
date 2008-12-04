Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYLDJJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYLDJJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 04:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYLDJJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 04:09:06 -0500
Received: from cs-studio.ru ([195.178.208.66]:55668 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbYLDJJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 04:09:03 -0500
Date: Thu, 4 Dec 2008 12:09:00 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Pavel Machek <pavel@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, john@johnmccutchan.com,
       arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de, rlove@rlove.org,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       davidn@davidnewall.com, Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
Message-ID: <20081204090900.GA4615@ioremap.net>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org> <20081126082936.GB17525@ioremap.net> <20081204084309.GA2072@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204084309.GA2072@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 09:43:10AM +0100, Pavel Machek (pavel@suse.cz) wrote:
> Actually, does the kernel even know who initiated the i/o?
> 
> Take two threads, both mapping /etc/something , both of them writing
> through the mmap. Kernel sees dirty pages so it writes them back, but
> which thread is repsonsible for the write?

It depends. If write will be done with write() syscall, caller will be
stored. Otherwise inotify does not hook into page fault code afaics.

> > > And how does this work give that pids are (no longer) system-wide unique?
> > 
> > It gets pids from the caller's task_struct (via current), so its data is
> > as unique as process calling getpid() or syscall(__NR_gettid).
> 
> What happens on mmap()?

mmap() syscall is not processed by inotify.

-- 
	Evgeniy Polyakov
