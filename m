Return-Path: <linux-kernel-owner+w=401wt.eu-S1030185AbXBPOaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbXBPOaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422637AbXBPO37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:29:59 -0500
Received: from lucidpixels.com ([75.144.35.66]:46071 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422635AbXBPO37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:29:59 -0500
Date: Fri, 16 Feb 2007 09:29:57 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: linux-usb-users@lists.sourceforge.net
Subject: 2.6.20 USB issue(?) [disabled by hub(EMI?)]
In-Reply-To: <Pine.LNX.4.64.0702031903550.29127@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0702160928550.13505@p34.internal.lan>
References: <Pine.LNX.4.64.0702031903550.29127@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This happens under heavy I/O + network traffic, it happened again, this 
time under 2.6.20-- is this normal/or would it be considered a bug? 
Because it does retry/re-discover the device.

==> /p34/var/log/messages <==
Feb 16 09:26:21 p34 kernel: [1007261.262023] usb 6-2: USB disconnect, 
address 2
Feb 16 09:26:21 p34 kernel: [1007261.363980] usb 6-2: new low speed USB 
device using uhci_hcd and address 3
Feb 16 09:26:22 p34 kernel: [1007261.527521] usb 6-2: configuration #1 
chosen from 1 choice
Feb 16 09:26:22 p34 kernel: [1007261.981395] hiddev96: USB HID v1.00 
Device [        UPS] on usb-0000:00:1d.1-2
==> /p34/var/log/kern.log <==
Feb 16 09:26:21 p34 kernel: [1007261.262013] hub 6-0:1.0: port 2 disabled 
by hub (EMI?), re-enabling...
Feb 16 09:26:21 p34 kernel: [1007261.262023] usb 6-2: USB disconnect, 
address 2
Feb 16 09:26:21 p34 kernel: [1007261.363980] usb 6-2: new low speed USB 
device using uhci_hcd and address 3
Feb 16 09:26:22 p34 kernel: [1007261.527521] usb 6-2: configuration #1 
chosen from 1 choice
Feb 16 09:26:22 p34 kernel: [1007261.981395] hiddev96: USB HID v1.00 
Device [        UPS] on usb-0000:00:1d.1-2


On Sat, 3 Feb 2007, Justin Piszcz wrote:

> Not sure if this is normal or not, was not doing anything out of the ordinary 
> and after secs/3600..  ~ 42hrs this occured?
>
> $ uptime
> 19:06:17 up 2 days, 29 min, 10 users,  load average: 0.13, 0.07, 0.06
>
> $ uname -ra
> Linux p34 2.6.20-rc7 #2 SMP Wed Jan 31 20:03:09 EST 2007 i686 GNU/Linux
>
> One thing I did recently was upgrade to a newer Intel Motherboard BIOS but 
> this is also the first time I have run 2.6.20-rc7 for this long as well.
>
> Any clues?
>
> [151698.814092] hub 6-0:1.0: port 2 disabled by hub (EMI?), re-enabling...
> [151698.814102] usb 6-2: USB disconnect, address 2
> [151698.917209] usb 6-2: new low speed USB device using uhci_hcd and address 
> 3
> [151699.078032] usb 6-2: configuration #1 chosen from 1 choice
> [151699.525889] hiddev96: USB HID v1.00 Device [        UPS] on 
> usb-0000:00:1d.1-2
>
> Mobo: Intel DG965WHMKR
> Bios: 1618 (latest)
>
> Could this have been from an apt-get update/upgrade?  Perhaps it upgraded 
> something that would probe/look at the USB bus?
>
> It is just the first time I have seen this and was wondering what the culprit 
> could be..
>
> Reading package lists... Done
> Reading package lists... Done
> Building dependency tree... Done
> Calculating upgrade... Done
> The following NEW packages will be installed
>  avahi-daemon libavahi-core4 libdaemon0
> The following packages will be upgraded:
>  adduser akregator alsa-utils apt-listchanges autoconf bsdutils dcoprss
>  ethereal-common gdm-themes geoip-bin kaddressbook kalarm kandy karm kcron
>  kdat kdeadmin kdeadmin-kfile-plugins kdenetwork kdenetwork-filesharing
>  kdenetwork-kfile-plugins kdepim kdepim-kfile-plugins kdepim-kio-plugins
>  kdepim-kresources kdepim-wizards kdict kdnssd kget kitchensync kleopatra
>  kmail kmailcvt knetworkconf knewsticker knode knotes konsolekalendar 
> kontact
>  kopete korganizer korn kpackage kpf kpilot kppp krdc krfb ksirc ksync ksysv
>  ktnef kuser kwifimanager libavahi-client-dev libavahi-client3
>  libavahi-common-data libavahi-common-dev libavahi-common3
>  libavahi-compat-libdnssd1 libavahi-glib1 libavahi-qt3-1 libc6 libc6-dev
>  libgeoip1 libgtk2.0-0 libgtk2.0-bin libgtk2.0-common libgtk2.0-dev 
> libindex0
>  libkcal2b libkdepim1a libkgantt0 libkleopatra1 libkmime2 libkpimexchange1
>  libkpimidentities1 libksieve0 libktnef1 libmimelib1c2a libnss-mdns
>  libpoppler0c2 libpoppler0c2-qt libpq4 librss1 libsane lilo locales logcheck
>  logcheck-database logtail mailgraph mount networkstatus pure-ftpd
>  pure-ftpd-common sane sane-utils squid squid-common sysstat util-linux w3m
>  wireshark wireshark-common x11-common xlibs-data xorg xserver-xorg
>  xserver-xorg-input-all xserver-xorg-video-all xserver-xorg-video-i810 xterm
> 113 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
> Need to get 77.0MB of archives.
>
> Any ideas?
>
> Thanks,
>
> Justin.
>
