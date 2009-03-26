Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbZCZWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbZCZWBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbZCZWBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:01:10 -0400
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com ([212.74.114.4]:15734
	"EHLO mk-outboundfilter-5-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbZCZWBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:01:09 -0400
X-Trace: 144251580/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.11.44/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-MUA: KMail/1.9.10
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAEKYy0lTQwss/2dsb2JhbACBUNMig3cG
X-IronPort-AV: E=Sophos;i="4.38,428,1233532800"; 
   d="scan'208";a="144251580"
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Resume after hibernation regression in 2.6.29
Date: Thu, 26 Mar 2009 22:01:03 +0000
User-Agent: KMail/1.9.10
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>
References: <200903261920.32173.tvrtko@ursulin.net> <20090326211406.GC29836@elf.ucw.cz> <200903262235.29576.rjw@sisk.pl>
In-Reply-To: <200903262235.29576.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903262201.03931.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 March 2009 21:35:29 Rafael J. Wysocki wrote:
> On Thursday 26 March 2009, Pavel Machek wrote:
> > On Thu 2009-03-26 20:55:23, Tvrtko A. Ursulin wrote:
> > > On Thursday 26 March 2009 20:18:40 Pavel Machek wrote:
> > > > On Thu 2009-03-26 19:20:32, Tvrtko A. Ursulin wrote:
> > > > > Hi guys,
> > > > > I have been running custom compiled 2.6.28.7 in OpenSUSE 11.1 and
> > > > > using hiberation/resume daily as configured by the distro.
> > > > > Yesterday I upgraded to 2.6.29 (make oldconfig from 2.6.28.7,
> > > > > attached) and after resume networking (at least) does not work.
> > > > > Reboot at this point takes very long because of timeouts on CIFS
> > > > > and whatelse.
> > > > >
> > > > > Below is how /var/log/messagess looks for one cycle
> > > > > (hibernate-resume-reboot) and I am also attaching kernel config and
> > > > > /var/log/pm-suspend.log.
> > > > >
> > > > > You will probably notice evil nvidia.ko in there but don't panic,
> > > > > it all happens without it as well. Tested from runlevel 3 and by
> > > > > running pm-hibernate. After resume from that NIC LEDs were off. I
> > > > > tried /etc/init.d/network restart but that hung so I ^C and tried
> > > > > rmmod forcedeth && modprobe forcedeth && ifup eth0 and after some
> > > > > time network went live again. Haven't had time to test further
> > > > > though, so this is all pretty rough.
> > > >
> > > > Ok, can you try to rmmod forcedeth before hibernation, then insmod it
> > > > after resume?
> > >
> > > Sure, after insmod and /etc/init.d/network start following resume
> > > network was fine. Guess I could kludge that sequence into pm scripts
> > > somehow but would rather avoid that since it slows down the cycle and
> > > would make scripts non-stock.
> >
> > Ok, I guess you need to talk to forcedeth maintainers then... sounds
> > like a forcedeth problem to me.
>
> I have a box with forcedeth somewhere here, I should be able to check that
> in the next few days.

Not a lot activity in forcedeth.c from 2.6.28 to 2.6.29 so I will CC two guys 
who commited changes in that period. Ayaz, Tobias, forcedeth does not seem to 
come up after hibernation well for me. Actual hardware is:

00:0f.0 Ethernet controller: nVidia Corporation MCP73 Ethernet (rev a2)

Anything more I can do just shout!

Tvrtko



