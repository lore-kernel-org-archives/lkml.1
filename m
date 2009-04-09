Return-Path: <linux-kernel-owner+w=401wt.eu-S1766003AbZDIVNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766003AbZDIVNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbZDIVNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:13:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38586 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759773AbZDIVNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:13:39 -0400
Date: Thu, 9 Apr 2009 23:15:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] Make relatime default
Message-ID: <20090409211501.GC3269@elf.ucw.cz>
References: <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org> <20090326184838.26166549@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903261525560.3032@localhost.localdomain> <20090409194624.GB1403@ucw.cz> <alpine.LFD.2.00.0904091343110.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904091343110.4583@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-04-09 13:47:37, Linus Torvalds wrote:
> 
> 
> On Thu, 9 Apr 2009, Pavel Machek wrote:
> > 
> > 'No changes of ABI in stable series?'
> 
> (a) we don't have a stable series any more
> and
> (b) this isn't an abi change, it's a system management change.

Well, stat() syscall no longer returns sane value in st_atime, while
all the userland stayed the same; only kernel changed. I believe that
is ABI change.

> If you don't think we can make those, then I assume that you also claim 
> that we can't do thigns like commit 1b5e62b42, which doubled the writeback 
> dirty thresholds, or any of the things that changed how dirty accounting 
> was done in the first place?

Writeback dirty thresholds will only change timing, that was not part
of ABI. st_atime field is.

> I would _love_ for distros to do the sane thing, but they don't. That's a 
> fact.

But is this a way to do it? Are there maybe better ways? 

a) Publicly call those distros broken? 

b) Add nasty printk() to mount to force their attention?

	bb) Add nasty printk() and mdelay(1000) to really force their
		attention? :-)

c) Modify mount command to do the dirty work instead of changing
default in kernel?

	[as mountflags are not passed as a string by sys_mount(), you
	are creating pretty nasty situation for users; users with old
	distro but new kernel will not be even able to get old
	behaviour back w/o updating /sbin/mount. This would prevent
	it].
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
