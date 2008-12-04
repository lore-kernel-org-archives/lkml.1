Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYLDIlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYLDIlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbYLDIlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:41:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49447 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbYLDIlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:41:21 -0500
Date: Thu, 4 Dec 2008 09:43:10 +0100
From: Pavel Machek <pavel@suse.cz>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, john@johnmccutchan.com,
       arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de, rlove@rlove.org,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       davidn@davidnewall.com, Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
Message-ID: <20081204084309.GA2072@elf.ucw.cz>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org> <20081126082936.GB17525@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126082936.GB17525@ioremap.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-11-26 11:29:36, Evgeniy Polyakov wrote:
> On Wed, Nov 26, 2008 at 12:15:38AM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> > OK, so we have a super-duper framework which will allow us to add pids
> > (and other things) to inotify messages.
> 
> Yup :)
> 
> > This still doesn't provide a reason for anyone to be interested in the
> > code!  Why do we want pids in inotify messages?
>  
> I actually cared only about myself :)
> I started the thread and implementation, because my application has to
> differentiate IO made by itself and any IO made by system (another
> users, crons, whatever else), inotify did not give me that info, so I
> extended it. As of others: PID/TID may be used by watching applications
> to reduce own load to not process own IO, things like beagle may show
> who actually made changes into the file.

Actually, does the kernel even know who initiated the i/o?

Take two threads, both mapping /etc/something , both of them writing
through the mmap. Kernel sees dirty pages so it writes them back, but
which thread is repsonsible for the write?
 
> > And how does this work give that pids are (no longer) system-wide unique?
> 
> It gets pids from the caller's task_struct (via current), so its data is
> as unique as process calling getpid() or syscall(__NR_gettid).

What happens on mmap()?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
