Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZAZTbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZAZTbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZAZTbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:31:40 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:48319 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZAZTbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:31:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KC0KAXq9qp64NjnV8LJczcixhPsvLBEO10d9efe/oaJrkZGlgQi38dIGm/AgqMeQZ7
         VqNRXHB+ylT4tfyYkLtA49ofWX9HGpGVJRQuCZNMBqdfjrqMhTRIM3dN+9LVQwMKz7dd
         QmKG3iGsVFjTFKUBDaDmiQgIwY8Jq3+B5DR80=
Message-ID: <497E0F94.8000003@gmail.com>
Date: Mon, 26 Jan 2009 20:31:32 +0100
From: Sandro Bonazzola <sandro.bonazzola@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Pavel Machek <pavel@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in	wb35_probe()
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI> <20090122114237.GA13845@atrey.karlin.mff.cuni.cz> <4978C812.90702@gmail.com> <20090122211052.GA1928@elf.ucw.cz> <4978F47C.6010909@gmail.com> <4978F3CF.2010301@cs.helsinki.fi>
In-Reply-To: <4978F3CF.2010301@cs.helsinki.fi>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pekka Enberg ha scritto:
> Ok, test done with git current version of w35und over 2.6.28-gentoo-r1
> (2.6.28.1
> and some patches)

Adding Pekka's patch

> # uname -a
> Linux arilinn 2.6.28-gentoo-r1 #1 Wed Jan 21 19:37:07 CET 2009 x86_64 AMD
> Athlon(tm) 64 Processor 3500+ AuthenticAMD GNU/Linux


# dmesg
skge eth0: Link is down.
skge eth0: Link is up at 100 Mbps, full duplex, flow control none
usb 1-3: new high speed USB device using ehci_hcd and address 4
usb 1-3: configuration #1 chosen from 1 choice
usb 1-3: New USB device found, idVendor=18e8, idProduct=6201
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-3: Product: Usb2Wlan
usb 1-3: Manufacturer: WINBOND
usb 1-3: SerialNumber: 101d350112
w35und: module is from the staging directory, the quality is unknown, you have
been warned.
phy0: Selected rate control algorithm 'minstrel'
usbcore: registered new interface driver w35und


# iwlist wlan0 scan
wlan0     Interface doesn't support scanning : Network is down

# ifconfig wlan0 10.0.4.1

# ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:0d:f0:2e:42:e7
          inet addr:10.0.4.1  Bcast:10.255.255.255  Mask:255.0.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

# iwlist scan
lo        Interface doesn't support scanning.

eth0      Interface doesn't support scanning.

eth1      Interface doesn't support scanning.

ppp0      Interface doesn't support scanning.

wmaster0  Interface doesn't support scanning.

wlan0     Scan completed :
          Cell 01 - Address: 02:A6:21:59:01:00
                    ESSID:"home"
                    Mode:Ad-Hoc
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality:0  Signal level:0  Noise level:0
                    Encryption key:off
                    IE: Unknown: 0004686F6D65
                    IE: Unknown: 010482848B96
                    IE: Unknown: 030101
                    IE: Unknown: 06020000
                    IE: Unknown: 00B247DA2800218B0000000040420F000000000080841E
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
                    Extra:tsf=0000000004a83302
                    Extra: Last beacon: 161ms ago


# ping 10.0.4.1
PING 10.0.4.1 (10.0.4.1) 56(84) bytes of data.
64 bytes from 10.0.4.1: icmp_seq=1 ttl=64 time=0.064 ms
64 bytes from 10.0.4.1: icmp_seq=2 ttl=64 time=0.060 ms


#dmesg:
usb 1-3: new high speed USB device using ehci_hcd and address 4
usb 1-3: configuration #1 chosen from 1 choice
usb 1-3: New USB device found, idVendor=18e8, idProduct=6201
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-3: Product: Usb2Wlan
usb 1-3: Manufacturer: WINBOND
usb 1-3: SerialNumber: 101d350112
w35und: module is from the staging directory, the quality is unknown, you have
been warned.
phy0: Selected rate control algorithm 'minstrel'
usbcore: registered new interface driver w35und
wbsoft_add interface called
wbsoft_config called
Going to channel: 1/1
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
wbsoft_config called
Going to channel: 1/1
wbsoft_config called
Going to channel: 1/1
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
skge eth0: Link is down.
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
wbsoft_config called
Going to channel: 1/1
wbsoft_config called
Going to channel: 1/1
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
wbsoft_config called
Going to channel: 1/1
wbsoft_config called
Going to channel: 1/1
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
wbsoft_config called
Going to channel: 1/1
wbsoft_config called
Going to channel: 1/1
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here
wbsoft_config called
Going to channel: 1/1
wbsoft_config called
Going to channel: 1/1
Should call ether_crc here
Should call ether_crc here
Should call ether_crc here



Ok, with kernel 2.6.8.1, and your patch it seems to work with channel 1, no
encryption, opensystem authentication.

- --
Sandro
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkl+D5QACgkQV871CybFezluagCcCzepY3jKrRxXKyg/YdvMfwQ0
ixQAn0eTkk5/cyblnhvsobBfjPsATAhm
=O5Wx
-----END PGP SIGNATURE-----
