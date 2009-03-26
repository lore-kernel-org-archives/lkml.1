Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbZCZRIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbZCZRIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759599AbZCZRHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:07:49 -0400
Received: from THUNK.ORG ([69.25.196.29]:60834 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759850AbZCZRHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:07:48 -0400
Date: Thu, 26 Mar 2009 13:07:14 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326170714.GF6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
References: <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 09:20:14AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 26 Mar 2009, Theodore Tso wrote:
> >
> > Most distributions are putting relatime into /etc/fstab by
> > default, but we haven't changed the mount option.
> 
> I don't think this is true. Fedora certainly does not. Not in F10, not in 
> F11. 

Ubuntu does.   I thought Fedora had, but I stand corrected.

> And quite frankly, even if you then _manually_ put 'relatime' in 
> /etc/fstab, the default Fedora install will totally ignore it. Why? 
> Because it mounts the root partition while using initrd, and totally 
> ignores /etc/fstab.

You can, actually, but it requires hacking /boot/grub/menu.list.  The
boot command option "rootflags=noatime" should do it, if their initrd
scripts are at all sane (and they honor rootfstype, so they probably
do also honor rootflags).

The question is whether we can make Fedora 11 and OpenSUSE do the
right thing now that this has become a highly visible discussion.  I'm
actually fairly optimistic on this front.  (Maybe some distro folks
will care to chime in on whether upcoming releases of F11 and OpenSuSE
can be changed to DTRT?)

Actually, given where F11 is on its release schedule, I suspect it
would be *easier* for them to make a change to default boot options in
grub's menu.conf than it would be backport a kernel patch, since they
will be releasing their beta release within the week, and their final
development freeze is in less than two weeks.

						- Ted
