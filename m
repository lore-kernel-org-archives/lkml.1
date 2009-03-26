Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbZCZSZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbZCZSZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbZCZSZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:25:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38935 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbZCZSZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:25:21 -0400
Date: Thu, 26 Mar 2009 14:23:20 -0400
From: Bill Nottingham <notting@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326182320.GA9341@nostromo.devel.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
References: <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326173237.GB8465@nostromo.devel.redhat.com> <alpine.LFD.2.00.0903261039480.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903261039480.3032@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds (torvalds@linux-foundation.org) said: 
> > Linus Torvalds (torvalds@linux-foundation.org) said: 
> > > And quite frankly, even if you then _manually_ put 'relatime' in 
> > > /etc/fstab, the default Fedora install will totally ignore it. Why? 
> > > Because it mounts the root partition while using initrd, and totally 
> > > ignores /etc/fstab.
> > 
> > It should honor /etc/fstab changes, if the initramfs is rebuilt
> > after the change is made. If it doesn't, that's a bug.
> 
> Why the hell should I rebuild initramfs? 

Well, it's got to find the root fs options somewhere. Pulling them
from the modified /etc/fstab in the root fs before you mount it, well...

As for why fstab options aren't applied with remount once the root
fs has been mounted, 1) historical reasons 2) someone specifies
'data=writeback' or similar can't-be-applied-with-remount flag in
/etc/fstab, and then mount refuses to remount it at all, and the
system refuses to boot. Arguably pilot error, of course.

Bill
