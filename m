Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZHHKge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZHHKge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 06:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZHHKgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 06:36:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57703 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbZHHKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 06:36:32 -0400
Date: Sat, 8 Aug 2009 12:36:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Paris <eparis@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, a.p.zijlstra@chello.nl,
       tvrtko.ursulin@sophos.com, douglas.leeder@sophos.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, tytso@mit.edu, arjan@infradead.org, david@lang.hm,
       jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       mmorley@hcl.in
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090808103626.GC9978@elf.ucw.cz>
References: <1248466429.3567.82.camel@localhost> <4A7AAE89.20205@sophos.com> <1249554548.32113.137.camel@twins> <200908061159.45550.tvrtko.ursulin@sophos.com> <1249557831.32113.234.camel@twins> <1249582695.20644.35.camel@dhcp231-106.rdu.redhat.com> <E1MZSQZ-0002as-FA@pomaz-ex.szeredi.hu> <1249666990.2694.6.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249666990.2694.6.camel@dhcp231-106.rdu.redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-08-07 13:43:10, Eric Paris wrote:
> On Fri, 2009-08-07 at 18:36 +0200, Miklos Szeredi wrote:
> > On Thu, 06 Aug 2009, Eric Paris wrote:
> > > just work.  The whole reason for the timeout is because I don't trust
> > > userspace not to get it wrong and I'd rather not lose my box because of
> > > it.
> > 
> > IMO this has nothing to do with userspace(*) and everything to do with
> > complexity.  Virus scanning is complex and any such code, whether
> > runing in userspace or not, can easily screw up and freeze the system.
> 
> I agree, 'userspace' was not the best term.  Let me rephrase:
> 
> "The whole reason for the timeout is because I don't trust anything not
> to get it wrong and I'd rather not lose my box because of it."
> 
> > The way to solve that is not to implement hacks on the kernel
> > interface, but rather by separating the complex parts and implementing
> > a simple watchdog layer on top of that, that makes sure things don't
> > go wrong.
> 
> So you would argue that every fanotify listener implement their own
> watchdog layer that may or may not be correct rather than do a single
> watchdog layer for everyone?  And that's better?

Yes.

(You can do library, and maybe you can just make fanotify listener
simple enough. Or you can just scrap the open vetoing [mis]feature).
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
