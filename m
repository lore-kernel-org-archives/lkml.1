Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbZBFUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbZBFUKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZBFUKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:10:08 -0500
Received: from main.gmane.org ([80.91.229.2]:36689 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbZBFUKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:10:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: Soft lockup in sungem on Netra AC200 when switching interface up
Date: Fri, 6 Feb 2009 19:45:18 +0000
Message-ID: <slrngop4qe.rks.alex@woodchuck.wormnet.eu>
References: <20090206112902.GS4362@tango.lnet.fi>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: woodchuck.wormnet.eu
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ilkka Virta <itvirta@iki.fi> [Fri, 6 Feb 2009 13:29:02 +0200]:
> What ho, chaps
>
> The sungem network driver seems to be broken with the integrated
> Ethernet ports of a Sun Netra T1 AC200. On that machine, switching the
> interface up when link is up leads to a soft lockup. However,
> switching the interface up with no link, and only then connecting the
> cable works; as does the same driver on seemingly same hardware on a
> Sun Blade 1000.
>
Et tu Brute?

> lspci doesn't show any real differences between the gems on the Netra
> and on the Blade, both are these: 
> 0000:00:05.1 Ethernet controller [0200]: Sun Microsystems Computer
>              Corp. RIO 10/100 Ethernet [eri] [108e:1101] (rev 01)
>
> Earlier reports of the same problem indicate that the driver was
> broken by commit bea3348eef27e6044b6161fd04c3152215f96411 in around
> 2.6.24, but the problem still exists in 2.6.28.
>
> http://kerneltrap.org/mailarchive/linux-kernel/2008/8/7/2856094
> http://bugzilla.kernel.org/show_bug.cgi?id=10309
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=508151
>
> Now, I didn't find any ready-made cure for this, so I poked around the
> driver a bit to see what happens. What follows is very much only
> guesswork, since I don't really know anything about Linux network
> drivers.
>
I live with the following:
----
# The primary network interface (right hand side port)
auto eth0
iface eth0 inet static
  address 77.75.105.223
  netmask 255.255.255.0
  gateway 77.75.105.1

  pre-up ethtool -s eth0 autoneg off
  pre-up ethtool -s eth1 autoneg off
  pre-up ethtool -s eth0 autoneg on
----

Seems to make it work...the autonegoation caused it to sulk if the cable 
was in for us.  The above worked, and has since I started using it.  We 
are running 2.6.24 but I'm pretty sure the problem was there back on 
2.6.18.  I have a spare Netra in my attic for testing but last time I 
reported this no one seemed to care so I lived with my 'workaround'.

As a side note, do you find the cpufreq scaling locks up your machine 
instantly without even an oops?

Cheers

-- 
Alexander Clouter
.sigmonster says: Hold the MAYO & pass the COSMIC AWARENESS ...

