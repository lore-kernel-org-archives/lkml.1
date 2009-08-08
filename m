Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZHHKey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZHHKey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 06:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZHHKey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 06:34:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57438 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZHHKex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 06:34:53 -0400
Date: Sat, 8 Aug 2009 12:34:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Douglas Leeder <douglas.leeder@sophos.com>,
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
Message-ID: <20090808103445.GB9978@elf.ucw.cz>
References: <1248466429.3567.82.camel@localhost> <4A7AAE89.20205@sophos.com> <1249554548.32113.137.camel@twins> <200908061159.45550.tvrtko.ursulin@sophos.com> <1249557831.32113.234.camel@twins> <1249582695.20644.35.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249582695.20644.35.camel@dhcp231-106.rdu.redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > By the above you're hosed anyway since starting a new one will fail due
> > to there being no daemon, right? Might as well forfeit all security
> > measures once the daemon dies. That is let security depend on there
> > being a daemon connected.
> 
> Nope.  You should stop calling and thinking of it as a security system.
> As I've said multiple times it is at best an indexing and integrity
> checking system.  We fail open.  We don't prevent or care about
> malicious local attacks.  When a group is evicted everything is going to
> just work.  The whole reason for the timeout is because I don't trust
> userspace not to get it wrong and I'd rather not lose my box because of
> it.  Yes, the reset I'm proposing allows userspace to screw the

Well, if you are using this for hierarchical storage, then this daemon
will bring the system down.

Face it, you _are_ developing a security system; otherwise features of
fanotify do not make sense. (And you are developing _bad_ security
system).

So... what about just scrapping the open vetoing -- at least from
initial version?

> > Seems like a weird thing to me, suppose you DoS the system on purpose
> > and all clients start getting wonky, you kill them all, and are left
> > with non, then you cannot access any of your files anymore and
> > everything grinds to a halt?
> 
> Nope, you DoS the system on purpose all the listeners get evicted, now
> everything else will be able to open/read data without those listeners
> paying attention.  When a group is evicted it's evicted.  It no longer
> needs to say yes or no.

Yes so I hammer your web server and you loose your antivirus
protection. 

> > Like said, having the filesystem block actions based on external
> > processes seems just asking for trouble.
> 
> Or it seems like exactly what hierarchical storage management systems
> want....

Timeout does not make sense for hierarchical storage.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
