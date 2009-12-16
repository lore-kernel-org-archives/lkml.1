Return-Path: <linux-kernel-owner+w=401wt.eu-S933807AbZLPNKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbZLPNKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZLPNKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:10:02 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:58711 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbZLPNKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:10:01 -0500
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
 2.6.32-git1
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andi Kleen <andi@firstfloor.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091216005308.GB3622@basil.fritz.box>
References: <20091207115949.GA7610@basil.fritz.box>
	 <20091207211216.E95E.A69D9226@jp.fujitsu.com>
	 <20091207132009.GI18989@one.firstfloor.org>
	 <20091215222134.GA27892@ZenIV.linux.org.uk>
	 <20091215233841.GE22392@basil.fritz.box>
	 <1260921277.3219.18.camel@localhost>
	 <20091216005308.GB3622@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 08:09:51 -0500
Message-Id: <1260968991.3219.57.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 6 sum msgs/h 1 total rcpts 2050 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 4C258D7C180C326CFE686EFB5704BB01B5C8FD91
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 45 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 01:53 +0100, Andi Kleen wrote: 
> > If you want to work around the problem rather than going for something
> 
> I am mostly interested in making the ugly warning on my systems
> go away, preferably without breaking anything in the process.
> Whatever works.
> 
> > like Peter's split up of the mmap() callback, then I'd suggest changing
> > to using nfs_revalidate_mapping_nolock() instead. The fact that we are
> > seeing these lock misordering warnings is proof that the call to
> > nfs_revalidate_mapping() is not always a no-op.
> 
> I would say the interesting question is if there is really a expectation
> that mmap does this kind of synchronization? 

Usually people who set the 'noac' mount flag will expect these syscalls
to act as synchronisation points.

Typically, their applications will be using some kind of locking scheme
that does not require POSIX or BSD locks to be set. For instance, they
may synchronise by means of a token passed through a socket (common in
MPI iirc).

> Why in mmap, not somewhere else?

We do the same thing in the read() and write() syscalls.

Cheers
  Trond

