Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZHFLYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZHFLYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZHFLYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:24:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54512 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbZHFLYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:24:44 -0400
Date: Thu, 6 Aug 2009 13:24:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Leeder <douglas.leeder@sophos.com>,
       Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090806112438.GJ31370@elf.ucw.cz>
References: <1248466429.3567.82.camel@localhost> <4A7AAE89.20205@sophos.com> <1249554548.32113.137.camel@twins> <200908061159.45550.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908061159.45550.tvrtko.ursulin@sophos.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > Of course, I'm worried about failing to meet this on loaded
> > > > system. And the fact that I _have_ to worry about that means that
> > > > interface is ugly/broken.
> > >
> > > You mean that in 5 seconds, you won't have any point when you can tell
> > > the kernel, "I'm still working"?
> >
> > I have to agree with Pavel here, either you demand the monitor process
> > is RT/mlock and can respond in time, in which case the interface doesn't
> > need a 5 second timeout, or you cannot and you have a hole somewhere.
> >
> > Now having the kernel depend on any user task to guarantee process is of
> > course utterly insane too.
> >
> > Sounds like a bad place to be, and I'd rather not have it.
> >
> > If you really need the intermediate you might as well use a FUSE
> > filesystem, but I suspect there's plenty of problems there as well.
> 
> So you mount FUSE on top of everything if you want to have systemwide 
> monitoring and then you _again_ depend on _userspace_, no? By this logic 
> everything has to be in kernel. But even if it was, and the CPUs are so 
> overloaded that an userspace thread does not get to run at all for X seconds, 
> are kernel threads scheduled differently eg. with priority other than nice 
> levels?

Userspace app not running for 5 seconds != CPU not being available for
5 seconds. I'd worry about swap behaviour here.

> If the timeout is made configurable I think this is the best that can be done 
> here. I don't think the problem is so huge as you are presenting it.

It is ugly. FUSE is more elegant, being already in kernel. Of course,
if your userspace daemon fails, you are doomed, but...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
