Return-Path: <linux-kernel-owner+w=401wt.eu-S1761759AbZCZWgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761759AbZCZWgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760316AbZCZWgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:36:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43004 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761546AbZCZWgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:36:09 -0400
Date: Thu, 26 Mar 2009 23:38:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: Resume after hibernation regression in 2.6.29
Message-ID: <20090326223855.GF29836@elf.ucw.cz>
References: <200903261920.32173.tvrtko@ursulin.net> <20090326211406.GC29836@elf.ucw.cz> <200903262235.29576.rjw@sisk.pl> <200903262201.03931.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903262201.03931.tvrtko@ursulin.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-03-26 22:01:03, Tvrtko A. Ursulin wrote:
> On Thursday 26 March 2009 21:35:29 Rafael J. Wysocki wrote:
> > On Thursday 26 March 2009, Pavel Machek wrote:
> > > On Thu 2009-03-26 20:55:23, Tvrtko A. Ursulin wrote:
> > > > On Thursday 26 March 2009 20:18:40 Pavel Machek wrote:
> > > > > On Thu 2009-03-26 19:20:32, Tvrtko A. Ursulin wrote:
> > > > > > Hi guys,
> > > > > > I have been running custom compiled 2.6.28.7 in OpenSUSE 11.1 and
> > > > > > using hiberation/resume daily as configured by the distro.
> > > > > > Yesterday I upgraded to 2.6.29 (make oldconfig from 2.6.28.7,
> > > > > > attached) and after resume networking (at least) does not work.
> > > > > > Reboot at this point takes very long because of timeouts on CIFS
> > > > > > and whatelse.
> > > > > >
> > > > > > Below is how /var/log/messagess looks for one cycle
> > > > > > (hibernate-resume-reboot) and I am also attaching kernel config and
> > > > > > /var/log/pm-suspend.log.
> > > > > >
> > > > > > You will probably notice evil nvidia.ko in there but don't panic,
> > > > > > it all happens without it as well. Tested from runlevel 3 and by
> > > > > > running pm-hibernate. After resume from that NIC LEDs were off. I
> > > > > > tried /etc/init.d/network restart but that hung so I ^C and tried
> > > > > > rmmod forcedeth && modprobe forcedeth && ifup eth0 and after some
> > > > > > time network went live again. Haven't had time to test further
> > > > > > though, so this is all pretty rough.
> > > > >
> > > > > Ok, can you try to rmmod forcedeth before hibernation, then insmod it
> > > > > after resume?
> > > >
> > > > Sure, after insmod and /etc/init.d/network start following resume
> > > > network was fine. Guess I could kludge that sequence into pm scripts
> > > > somehow but would rather avoid that since it slows down the cycle and
> > > > would make scripts non-stock.
> > >
> > > Ok, I guess you need to talk to forcedeth maintainers then... sounds
> > > like a forcedeth problem to me.
> >
> > I have a box with forcedeth somewhere here, I should be able to check that
> > in the next few days.
> 
> Not a lot activity in forcedeth.c from 2.6.28 to 2.6.29 so I will CC two guys 
> who commited changes in that period. Ayaz, Tobias, forcedeth does not seem to 
> come up after hibernation well for me. Actual hardware is:
> 
> 00:0f.0 Ethernet controller: nVidia Corporation MCP73 Ethernet (rev a2)
> 
> Anything more I can do just shout!

Actually yes. Testing forcedeth from 2.6.28 in 2.6.29 would be nice
way to prove problem is indeed in that module.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
