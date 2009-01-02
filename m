Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbZABTZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbZABTZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758839AbZABTZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:25:43 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:36237 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbZABTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:25:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=cltF6QjXLi+/KWtcf1HB5i8KmQCCffkJAQn2rzkEzLzP0/VYQGWBZ6N2kYW9533bP/
         WNGjHeatej1gBocn9cQd2qSlWArjh7jFvK3k+gRJNQZWPb49j8ajbTI6CF/iUyNH60Y5
         YizNz5yew99MFgTa9vIpAh+lWPBW6Im221CDI=
Message-ID: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
Date: Fri, 2 Jan 2009 13:25:38 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>,
       Goodgerster <goodgerster@gmail.com>, burdell@iruntheinter.net
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slashdot reported a story of Linux machines crashing on New years eve.

http://ask.slashdot.org/article.pl?sid=09/01/01/1930202

Below follows a summary of the reported crashes. I'm ignoring the
zillions of "mine didn't crash" reports, or the "you're a paranoid
conspiracy theorist, its random chance" reports.

So far, 31 users reported 53 hard crashes at/near midnight, new years.
Symptoms are:
-- hard hang (systems not pingable)
-- irq's not serviced (if disk was active at time of crash,
   the disk activity light stays lit)
-- cold reboot (poweroff) required
-- systems work normally after reboot
-- no messages in syslog, no kernel oops, no core file crash dumps
-- not reproducible (simply setting the clock back is not enough
   to reproduce; guessing that a simulation of stratum 0 ntp server
   is needed to force the leap-second.)
-- The affected machines seem to be running either 2.6.21, 2.6.26 or 2.6.27

Suspect its an kernel race condition triggered by ntp bumping the second.
-- its the leap second, since this doesn't happen other years,
-- its a race condition, since some identically configured machines
   didn't go down, while others did.
-- its a race condition, since majority of systems were not affected.
-- its a race condition, since affected systems seem to have been
   mostly non-idle servers, or some non-idle desktops/ tv set-tops.
-- ntpd is the only service that monkeys with time adjustments.

There is a "well-known" deadlock in 2.6.21 kernels that caused this:
http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg15039.html

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=746976a301ac9c9aa10d7d42454f8d6cdad8ff2b;hp=872aad45d6174570dd2e1defc3efee50f2cfcc72

Here's the synopsis of individual reports.  Most folks left very little
info, nor did they leave a way to contact them.


aputerguy
Fedora 8 Linux server 2.6.26.6-49.fc8 Intel p4 2.8GHz.
ASUS P4PE 2 1-TB Seagate SATA hardrives, 1 200MB PATA drive. 2GB DDR. 1
pchdtv5500 card, 1 winfast 2000XP tv card, 1 nVidia 6200 graphics card.


MentalMooMan (785571)  <slashdotNO@SPAMjameshallam.info>
mythtv box (running mythbuntu) used to be something like 7.10 upgraded to 8.10
2.6.27-9.19-generic ntpd version 4.2.4p4. The CPU is an AMD Athlon XP
1700+ or 1800+.  The motherboard is an EPOX EP-8KTA3Pro. message in
/var/log/messages at boot-time:
"warning: `ntpd' uses 32-bit capabilities (legacy support in use)"


Anonymous Coward  MythTV box on Fedora 8 (Athlon XP1700+)


athakur999 (44340)  Mythbuntu-based HTPC


AZPolarBear (661815) Fedora 8 system


Anonymous Coward 5 of about 70 of our production servers


Anonymous Coward   I did have two 2.6.21 servers crash last night


Anonymous Coward Ubuntu 8.10 MythTV box.


SanjuroE (131728) Debian testing and at that time Debian kernel
2.6.26-11.


lukas84 (912874) internal testing machine that's still on 2.6.21


Anonymous Coward Debian testing Kernel 2.6.26


zerosumgame (1429741) kernel 2.6.21 on older Dell 1850's


Wibla (677432)  Both my fileservers running debian etch installed from
custom install media (pre-etchnhalf) running 2.6.21-2 and 2.6.21-6
crashed,


Maow (620678)  Ubuntu 8.04 on AMD64


Burdell (228580)  <burdell@iruntheinter.net> RHEL 4 server
RHEL 4 update 6
kernel-smp-2.6.9-67.0.7.EL.x86_64
ntp-4.2.0.a.20040617-6.el4.x86_64
Penguin Computing Altus 2600
dual dual-core Opteron 2212 HE
4G RAM
nVidia MCP55 chipset
I have 9 servers (mostly
different hardware, but one the same as above), all running the exact
same kernel and package set.  Only one crashed; the others logged the
leap second and went on fine.


Pretzalzz (577309) Travis Crump <pretzalz@techhouse.org>
http://lists.debian.org/debian-user/2009/01/msg00006.html
debian lenny ntp=1:4.2.4p4+dfsg-7;
Linux version 2.6.26-1-amd64 (Debian 2.6.26-4[since updated])
Processor  : 2x AMD Athlon(tm) 64 X2 Dual Core Processor 3800+


kst (168867) Ubuntu 8.10


arodland (127775) Debian 2.6.21


Goodgerster (904325)  <goodgerster AT gmail DOT com>
Debian


Morgor (542294)  Fedora 8 Two of our production servers running fedora 8


Lightjumper (532700) Fedora 9 server


blit (90883) 10 machines running Fedora Core 7


Qwell (684661) Ubuntu 8.10


Jim Fenton (514449) Fedora 8 machine (kernel: 2.6.26.6-49.fc8)


Anonymous Coward  My laptop


dmrobbin (560931)   F8 box went down,


Anonymous Coward  F8 server also "hung"


Anonymous Coward 2.6.26-1-amd64. Four of the 20 locked up


Anonymous Coward (actually, me, Linas) amd64 dual core, ubuntu 8.04
custom-compiled kernel, 2.6.26-64-bit


Anonymous Coward kernel 2.6.26.3-29.fc9.


Anonymous Coward  3 Ubuntu 8.10 Virtual Box (3 of them)
