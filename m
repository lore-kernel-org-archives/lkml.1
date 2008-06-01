Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbYFAXwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbYFAXwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYFAXwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:52:44 -0400
Received: from 1wt.eu ([62.212.114.60]:1404 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbYFAXwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:52:42 -0400
Date: Mon, 2 Jun 2008 01:50:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4 usage statistics (results)
Message-ID: <20080601235007.GA28469@1wt.eu>
References: <20080428202433.GA13417@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428202433.GA13417@hera.kernel.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've tried to summarize the usage reports I got for kernel 2.4.

[ Note: some of the responders asked to be notified when I send the
  results, so I've Bcc'd the responders so that they can get the
  results without being polluted by potential responses.            ]

About 22 useful responses. It is not possible to report accurate numbers
because most participants did not themselves have accurate numbers. I
would say that based on the responses (and a few cases I know), 2.4 usage
approximately follows this distribution :

 - old recycled laptops at home, or PDA/thin clients - ~5%
   They rely on whatever kernel managed to boot on them, then they never
   got updated anymore. Security generally not too much of an issue, no
   plan to update to newer 2.4, let alone 2.6. The hardware will die first.
   Sometimes a few patches were added to support one particular component
   or enable one feature specific to the use case. These boxes have the
   lowest level of criticity.

 - desktop PCs, monitoring stations - about the same as previous ones, with
   an increased level of criticity. Generally users have not upgraded simply
   because "it works". Those are systems with known fixed hardware and usage
   pattern. Most often they serve as X11 terminals and/or browsers, and do
   not require many updates. They cause trouble to the user(s) when they
   die and no benefit is expected from an upgrade to 2.6. Future installation
   (same or replaced hardware) will generally be on 2.6.

 - general purpose servers : regularly updated - about 50%.
   The pattern is most always the same. A lot of services are installed,
   among which WWW, Mail, DNS, Samba, NFS. The server never experiences
   any outage, and a moderate amount of people would be affected if a
   problem happened. Almost always up to date with latest 2.4. Reason
   for not upgrading to 2.6 generally is lack of need and time, as well
   as risks of regressions which would get a lot of users angry. Users
   per server are in the range of 10 to 1000. Generally some migration
   tests are in progress. Early attempts at 2.6 failed due to stability
   problems (GRE tunnels freezing, sparc images limited in size).

 - application specific servers : about 20%. Often mission-critical.
   Generally deployed with latest 2.4, and almost never updated.
   Long stress-tests before production. Generally the number of users
   does not mean anything, it's the process the system is involved in
   which makes sense. Pre-press workflow applications for daily
   newspapers and weather broadcasting for TV channels were reported.
   Reliability is the #1 requirement, and generally recent tests in
   2.6 have not been much satisfying. One reported DRBD 0.6 very reliable
   in 2.4, while DRBD 0.7 not as much in 2.6. Another one reported that
   the application needed to be ported to correctly work in 2.6.
   Interestingly, in all cases, the high level of criticity implies
   that 2.6 is still being evaluated, in the event that one day there
   is no choice (eg: due to hardware compatibility).

 - routers/firewalls/VPN/IDS : about 10%. Longest uptimes up to 5-600 days
   in business environments, implying kernel not often updated (avg once a
   year). For personal use, it's where the updates are the most common
   (probably due to the quick reboot and low impact of a short outage).
   One user reported a number of these boxes deployed in finance/business/train
   environments with high level of criticity, receiving occasional updates
   during dead hours. Generally no upgrade to 2.6 is planned (though I think
   it is where it might be the least painful). One user reported missing
   devfs in 2.6, too big kernel size, and no clear upgrade path. We might
   help them switch by enumerating the small number of changes in such a
   networked environment. What may be the most obscure in business environment
   is the lack of sight of long term reliability. I personally know about
   several firewalls I have deployed 5 years ago in a finance environment
   which see 1 million unique clients a day. It has been discussed about
   migrating them to 2.6 but it seems like the only way to know how long
   they will survive is to test in production, which is generally not
   acceptable. So leaving them on 2.4 is often the solution.

 - embedded systems : about 10% of the reports, probably more in terms of
   number of systems. They often expect very long uptimes (two of them
   reported rebooting less than once a year). This is either dictated by
   the fact that consumer electronics get bad reputation when failures or
   updates happen too often, or because the big customer does not want
   to update something which works. Reported usages include outdoor
   information displays for trains and busses, various consumer electronic
   devices including TV sets, monitoring systems and building security
   devices (eg door openers). Upgrade to 2.6 not needed nor planned at
   all for some, and planned for others to gain better hardware support.
   Some are still testing but experiencing regressions (eg: parport). In
   all cases, the build process has to be massively redesigned and this
   costs a lot of time and money. Not surprizing that some major network
   equipement manufacturer still ships device with and old 2.4.2 in them.

It is worth noting that several users still using 2.4 roll their own distro,
which will need to be substantially updated to support 2.6. This seems to be
one showstopper too, especially when the distro was designed for easy remote
and centralized upgrades. In this case, what seems to happen is that the old
version continues to live at existing locations, and a new version appears
with support for 2.6 for newer systems. But from an organisational point of
view, it's not always easy to manage two branches of a distro when only one
has been enough for years.

Surprizingly, it appears that very few users patch their kernels. Those who
do so have their own distros or build kernels for large amounts of machines
(eg: consultants doing so for their customers). Many of the reported patches
have found their way in mainline 2.6, but some have definitely vanished (eg:
devfs,linux-abi, kstat, umsdos, lvm). Among the patches, GRsecurity and PaX
were reported several times. Some special-purpose patches are included in
appliance products.

Vendor drivers are the only ones installed by most users who patch (eg:
3Ware 9xxx, sk98lin, bnx2). One user reported an annoying problem with USB
for which I realized I've been having a patch in my own tree for years, to
the point I completely forgot the problem existed. It is related to
USB-storage, where unplugging then replugging a device assigns it a new
SCSI drive name. I may merge it into 2.4.37.

Based on that and on the workflow people took the time to explain, I
realize that the distinction between -pre and -rc is useless (ding! Linus
if you read this, don't beat me). In fact, either people want absolute
reliability and they pick one kernel from the stable 2.4.X.Y branch, or
they want more recent updates and they simply do their shopping in the
-master branch, which is fairly easy thanks to the Gitweb interface.
But there are almost no testers in 2.4, just users. That means that I
don't have to expect immediate feedback when posting a pre-release. And
it has happened several times that I got a build error report several
weeks after the release.

Also, since most people do not update more than 1/2 times a year, it's
not very useful to have more than 1/2 new versions a year, expecially
since we have the stable release. For this reason, I think I will issue
stable releases a bit more often for users to quickly get their fixes,
but progressively increase the delay between major releases. Those ones
will only be issued with new PCI IDs, major driver updates, compiler
support, etc...

Last, I think users would benefit from an inventory of functional changes
between 2.4 and recent 2.6, with a reversible upgrade path, so that they
can experiment with 2.6 on their production machine and immediately go
back to 2.4 in case of trouble.

Well, I hope it was not too much boring!

Regards,
Willy

