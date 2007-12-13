Return-Path: <linux-kernel-owner+w=401wt.eu-S1762391AbXLMPZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762391AbXLMPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbXLMPZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:25:14 -0500
Received: from pat.uio.no ([129.240.10.15]:45196 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbXLMPZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:25:11 -0500
Subject: Re: [PATCH] NLM: Add lockd reference counting and clean up lockd
	startup and shutdown
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071213094009.7a7e1923@tleilax.poochiereds.net>
References: <1197118932-4512-1-git-send-email-jlayton@redhat.com>
	 <20071208140747.GA11675@infradead.org>
	 <20071213094009.7a7e1923@tleilax.poochiereds.net>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 10:24:49 -0500
Message-Id: <1197559489.11586.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=5.0, autolearn=disabled, AWL=-0.178)
X-UiO-Scanned: 78FE3BE7C36945B39F34FE31FEF213295346A24C
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 558 total 5730713 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 09:40 -0500, Jeff Layton wrote:
> On Sat, 8 Dec 2007 14:07:47 +0000
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > > +	mutex_lock(&nlmsvc_mutex);
> > > +	while (atomic_read(&nlmsvc_ref) != 0) {
> > 
> > might be better to do the refcounting outside the thread and use the
> > kthread api, which is something we still need to do for lockd anyway.
> > 
> 
> I took a swipe at doing this, and have a set of patches that make lockd
> use kthreads. It works well, but there's a problem once I add in the
> reference counting.
> 
> In the situation that prompted this whole thing, the last nlmsvc_ref
> gets put by lockd itself. A kthread can't call kthread_stop on itself
> since it will deadlock.
> 
> Is there a way to gracefully allow a kthread to shut itself down?
> Alternately, I suppose I could schedule_work() the kthread_stop, though
> that seems sort of ugly...

How about just 'return'? :-)

You shouldn't need to signal yourself to stop.

Cheers
  Trond

