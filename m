Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYK3OeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYK3OeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 09:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYK3OeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 09:34:15 -0500
Received: from web52710.mail.re2.yahoo.com ([206.190.48.233]:42826 "HELO
	web52710.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751605AbYK3OeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 09:34:14 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Nov 2008 09:34:14 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=tdyP2BJrV6jLl5BUCMZN+zupJ4jMD63aYL0PadVOVO/RnuzOFmS7L3z6Ng57RDMhBLH0XBACunwQw6lALKnqbmi2jKRytPpkFmE/w4jOSCeVnh5tLAyxAh9NPNrLSgARIKZ9hjsndQafbqmup+4yj6t/ZNBQMh3hBSK5IBNDF/U=;
X-YMail-OSG: HvE4MCMVM1lB.DT3qM5T5nM6mDXMPhrs3g5HCM_JoGShpgESFRqzxqaRcK0.2wDnldTOf5UvWketSLdHVwwxg3ebCqJ75rQ.kR4kKqqrUpVnvOHUH0AQhmFomTrYJ75g1kCNLfXb7wwNjSVASigKbCbyJ6TWqmiZGPwOXSs-
X-Mailer: YahooMailRC/1155.32 YahooMailWebService/0.7.260.1
Date: Sun, 30 Nov 2008 06:27:33 -0800 (PST)
From: Steve Moring <smoring@yahoo.com>
Subject: Intel dg45fc motherboard still bricks with e1000e driver
To: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <452705.18074.qm@web52710.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if I should enter a bug on this or not as I thought this
one was fixed already, but I have an Intel dg45fc that comes with a gig
enet card built in. If I force the connection to 100mb by connecting a
switch that is only capable of 100mb, all is good, as soon as I connect
it to a gig capable switch, it bricks the machine on the next reboot forcing me to reload
the bios.

Also, the "core multiplexing technology" option within the bios must be
turned off in order to load and run OpenSuse 11.1 at all. With this
option turned on within the bios, the machine will boot to grub, let
you select your boot option, will show about 5 lines on the screen (f2
quickly), then powers off/on.

I have tried the following combinations: x86_64 with and without XEN,
i586 with and without XEN, all behave identically with the above
observations.

smoring@linux-u6b7:~/Desktop> uname -r
2.6.27.7-4-xen

smoring@linux-u6b7:~/Desktop> /sbin/lspci
00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller (rev 03)
00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation 4 Series Chipset Integrated Graphics Controller (rev 03)
00:03.0 Communication controller: Intel Corporation 4 Series Chipset HECI Controller (rev 03)
00:19.0 Ethernet controller: Intel Corporation 82567LF-2 Gigabit Network Connection
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio Controller
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller

linux-u6b7:/home/smoring/Desktop # lspci -n
00:00.0 0600: 8086:2e20 (rev 03)
00:02.0 0300: 8086:2e22 (rev 03)
00:02.1 0380: 8086:2e23 (rev 03)
00:03.0 0780: 8086:2e24 (rev 03)
00:19.0 0200: 8086:10cd
00:1a.0 0c03: 8086:3a37
00:1a.1 0c03: 8086:3a38
00:1a.2 0c03: 8086:3a39
00:1a.7 0c03: 8086:3a3c
00:1b.0 0403: 8086:3a3e
00:1d.0 0c03: 8086:3a34
00:1d.1 0c03: 8086:3a35
00:1d.2 0c03: 8086:3a36
00:1d.7 0c03: 8086:3a3a
00:1e.0 0604: 8086:244e (rev 90)
00:1f.0 0601: 8086:3a16
00:1f.2 0101: 8086:3a20
00:1f.3 0c05: 8086:3a30
00:1f.5 0101: 8086:3a26

Please let me know if there is anything else that I can provide or test.

Thanks.



      
