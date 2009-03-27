Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZC0Nus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZC0Nus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZC0Nue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:50:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54207 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZC0Nud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:50:33 -0400
Date: Fri, 27 Mar 2009 09:47:51 -0400
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
Message-ID: <20090327134751.GA2354@nostromo.devel.redhat.com>
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
References: <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326173237.GB8465@nostromo.devel.redhat.com> <alpine.LFD.2.00.0903261039480.3032@localhost.localdomain> <20090326182320.GA9341@nostromo.devel.redhat.com> <alpine.LFD.2.00.0903261523060.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903261523060.3032@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds (torvalds@linux-foundation.org) said: 
> > Well, it's got to find the root fs options somewhere. Pulling them
> > from the modified /etc/fstab in the root fs before you mount it, well...
> 
> Umm.
> 
> The _only_ sane thng to do is to mount the root read-only from initramfs, 
> and then re-mount it with the options in the /etc/fstab later when you 
> re-mount it read-write _anyway_ (which may possibly be immediately, of 
> course).

Sure, and as said, as soon as you try to specify journal options (and
possibly others), this immediately fails. You can apply the options
one at a time, and decide some aren't fatal, or you can actually have
your later remount have code to drop specific options, requiring
implementation knowledge of any filesystem to be used. Or you say
people who specify journal options in fstab don't get to boot.

But if you blindly attempt to apply fstab options later in the remount,
some options will break.

Bill
