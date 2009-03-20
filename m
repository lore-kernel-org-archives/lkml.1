Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZCTWkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZCTWkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 18:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZCTWkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 18:40:01 -0400
Received: from mail.atheros.com ([12.36.123.2]:11406 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZCTWkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 18:40:00 -0400
Date: Fri, 20 Mar 2009 14:39:20 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Max Ott <Max.Ott@nicta.com.au>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Qasim Javed <qasimj@gmail.com>,
       Till Kamppeter <till.kamppeter@gmail.com>
Subject: Google Summer of Code 2009 -- Linux wireless testing project
Message-ID: <20090320213920.GC8120@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a list of information to help those students looking into the
Linux wireless GSoC 2009 "Automation of testing using mac80211_hwsim and Orbit"
project [0], part of the Linux Foundation set of GSoC projects:

https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009

In anyone has ideas to further help this project please just feel free to
chime in. I'm adding other potential mentors to the project, Maxx Ott
which might be signing up as a mentor for Orbit-related stuff and
Subrata Modak which seems to be familiar with the Linux testing project
(LTP).

I'll also recommend to subscribe to the wiki page for the test project
so you can get e-mails on changes to the wiki page.

Students can start by becoming familiar with iw [1] and using wpa_supplicant with
the nl80211 driver. We eventually want to not depend on wireless extensions so
the new cutting edge tests will all be based on the new nl80211 stuff which
both iw and wpa_supplicant can use. iw is strictly nl80211 based. Of course
we should still have things to test wireless-extensions but soon it may be
possible to live completely without them for new cfg80211 based drivers.

Then you can look at starting to quickly create an AP with the different
encryption options, and use a STA to associate to that AP quickly and easily
as well.

I have some old scripts which did this which you may feel free to
use/modify/disregard. There's one for AP [2] and one for STA [3].
Jouni also has some stuff for this and you can check it out via his
git gree:

git://w1.fi/srv/git/hostap.git

In there check out the hostap/mac80211_hwsim/tests/ directory.

A starting point would be to extend this with simple scripts which let
you test mac80211_hwsim to do certain individual taks one at a time. For
example gettings association completed and transfering some amount of data
using the different encryptions algorithms available would test the software
encryption with mac80211. That would be a good first easy step to become
familiar with what we want to accomplish with the project.

The idea is to build a list of tests which we can automate and run to
test against the wireless-testing tree completely in software. Once
these tests are in place we then use them to also test against individual
drivers using real hardware. Since its not expected that students will have
all the wireless hardware available we can leverage the kindness of folks
at Orbit [4] and use sandboxes [5] there during a reservation to test
the different hardware present there. Fortunately the list of cards available
in the Sandboxes [6] is pretty decent and can grow. Go read the Orbit
developer's section [7]. This is the hardware present so far:

  * Atheros AR5002X Mini PCI 802.11a/b/g
    (AR5212 MAC Baseband Processor + AR5112 Dual-band Radio-on-a-Chip)
  * Intel PRO/Wireless 2915ABG Network Connection Mini PCI 802.11a/b/g
  * GNURadio - USB (we won't be testing this)
  * zd1211 - USB 802.11g
  * RTL8185 - PCI 802.11bg
  * ISL3890 - Mini PCI 802.11bg (prism54)
  * Marvell Libertas 8388 802.11 USB 

We may also have Intel 5000 11n, and I think we have some 11n Atheros stuff too
and if not I'll be sure to mail them out ASAP. Surely this will depend on
coordination with the Orbit folks and we cannot simply expect everything to
be there but its a starting point.

Once we have a set of scripts we are happy with for mac80211_hwsim we
can save an image for re-use at Orbit with these scripts and that image
can be installed during a reserved time-slot for testing. Its advised
the automation of testing to make use of Orbit's own automation
infrastructure called OMF. These are used at Orbit for research purposes
but just as they are used for research purposes it can also be used to
automate tests. Some scripts may need to be ported to use OMF.

To start becoming familiar with the Orbit testbed and using OMF you can
read their tutorials [8]. I think OMF is completely open source, Maxx
correct me if I'm wrong. If so then we can always end up contributing to
it to enhance it should that be possible and needed.

So the end goal is to have a nice list of tests which we can run on
for mac80211, the driver infrastructure (through mac80211_hwsim) and
also for each driver either through Orbit or manually so users can run
them at home or so that the Linux Testing Project [9] can use. In the
end it would be nice to have a page online which we can go to and see
some results of tests for each driver and also for mac80211 internals.

If anyone has other idease or documentation that may be usable for the
students please chime in.

  Luis

[0] http://wireless.kernel.org/en/developers/GSoC/2009/Automation_of_testing
[1] http://wireless.kernel.org/en/users/Documentation/iw
[2] http://www.winlab.rutgers.edu/~mcgrof/qa/create-ap.sh.txt
[3] http://www.winlab.rutgers.edu/~mcgrof/qa/create-client.sh.txt
[4] http://www.orbit-lab.org/
[5] http://www.orbit-lab.org/wiki/SandBoxes
[6] http://www.orbit-lab.org/wiki/SandboxMap
[7] http://www.orbit-lab.org/wiki/Documentation/Developers
[8] http://www.orbit-lab.org/wiki/Tutorial
[9] http://ltp.sourceforge.net/
