Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbXCTVwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbXCTVwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbXCTVwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:52:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55153 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXCTVwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:52:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: strange keyboard lag after suspend testing
Date: Tue, 20 Mar 2007 22:56:04 +0100
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Len Brown <len.brown@intel.com>,
       Andreas Mohr <andi@rhlx01.fht-esslingen.de>, vojtech@suse.cz,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070320153332.GA5533@elf.ucw.cz> <20070320163113.GA5740@elf.ucw.cz> <20070320163826.GA7092@elf.ucw.cz>
In-Reply-To: <20070320163826.GA7092@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202256.05628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 March 2007 17:38, Pavel Machek wrote:
> Hi!
> 
> > > >> > I was testing suspend in 2.6.21-rc4 a lot, and now... machine feels
> > > >> > like someone added 50..100msec delay somewhere in keyboard
> > > >> > handling. Mouse does not seem affected. /proc/interrupts seem to
> > > >> > increase as they should, for both keyboard and mouse. Can someone
> > > >> > reproduce it? Any ideas how to debug it?
> > > >>
> > > >> Probably just asking the obvious:
> > > >> it's not a trivial "failed to re-configure repeat rate upon resume"
> > > >> (which one could rule out by running "kbdrate" again)
> > > >> but a lag in some interrupt handler or somewhere else deeper, right?
> > > >
> > > >No, it is not keyboard rate. Keyboard lags during normal typing,
> > > >sometimes letters come in groups of two or so...
> > > 
> > > I might start looking at embedded controller changes and switches. If
> > > ACPI misbehaves that could starve keyboard controller... But you
> > > said
> > 
> > Mouse _seems_ okay, but I'm not sure if I'd notice lag there.
> > 
> > > that mouse is OK... Hmm, what happens if you load evbug and type while
> > > watching syslog. Do you observe the same delays?
> > 
> > Hmm, seems that it only happens in X... so maybe it is some strange
> > scheduling artefact?
> > 
> > Hmm, something is wrong here:
> > 
> > On console, I get expected 4-5 ticks a second. In x in gnome-terminal,
> > I get this:
> 
> It gets weirder: I killed some tasks and now: (on unloaded system
> running X, notice that top latency was ~1sec at 33:09).
> 
> root@amd:~# while true ; do echo -n . ; sleep .2; date; done
> .Tue Mar 20 17:33:07 CET 2007
> .Tue Mar 20 17:33:07 CET 2007
> .Tue Mar 20 17:33:08 CET 2007
> .Tue Mar 20 17:33:08 CET 2007
> .Tue Mar 20 17:33:08 CET 2007
> .Tue Mar 20 17:33:08 CET 2007
> .Tue Mar 20 17:33:09 CET 2007
> .Tue Mar 20 17:33:10 CET 2007
> .Tue Mar 20 17:33:10 CET 2007
> .Tue Mar 20 17:33:10 CET 2007
> .Tue Mar 20 17:33:10 CET 2007
> .Tue Mar 20 17:33:10 CET 2007
> .Tue Mar 20 17:33:11 CET 2007
> .Tue Mar 20 17:33:11 CET 2007
> .Tue Mar 20 17:33:11 CET 2007
> .Tue Mar 20 17:33:12 CET 2007
> .Tue Mar 20 17:33:12 CET 2007
> 
> As soon as I load the cpu up with while1, machine starts to behave.
> 
> When I turn on bluetooth (USB), ACPI can no longer use C3, and machine
> starts to behave. Hmm?

Smells like a cpufreq problem or something related.

Greetings,
Rafael
