Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYAEPSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYAEPSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYAEPSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:18:40 -0500
Received: from server19320154104.serverpool.info ([193.201.54.104]:50335 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbYAEPSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:18:39 -0500
X-Greylist: delayed 1842 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jan 2008 10:18:38 EST
Message-ID: <477F9890.5050107@hauke-m.de>
Date: Sat, 05 Jan 2008 15:47:44 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Subject: rtl8187 rate control doesn't work
X-Enigmail-Version: 0.95.2
OpenPGP: id=95C58E7B;
	url=http://www.hauke-m.de/pgp-pubkey.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Now the compat-wireless-2.6 package is working and I get an Internet
connection with my rtl8187 based card. (It's on an ASUS P5B Deluxe)

I used the compat-wireless-2.6 package for this log, but I have the same
problem with the version integrated in kernel 2.6.24-rc6

The Access Point is some rooms away so the signal is not the best at my
location. When starting the device with no fixed rate it wants to
connect with 54MBit/s and as iwconfig says it was successful but I can't
ping any device in the wireless LAN. (it's the first part of the log)
The rate will not be slowed down it stays fixed at 54MBit/s.

After starting the device with rate fixed to 11M I get a connection to
the Access Point and iwconfig's output looks the same as without fixed
rate, but I'm able to ping the all devices in the network. (second part
of the log)
Now it slows down the rate to 1MBit/s

iwconfig looks like this (fixed rate to 11M):
wlan0 IEEE 802.11g  ESSID:"mehrtenswlan"
      Mode:Managed  Frequency:2.412 GHz  Access Point: 00:1A:XX:XX:XX:XX
      Bit Rate=1 Mb/s   Tx-Power=27 dBm
      Retry min limit:7   RTS thr:off   Fragment thr=2352 B
      Link Quality=50/64  Signal level=16/65
      Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
      Tx excessive retries:0  Invalid misc:0   Missed beacon:0

With no fixed rate there is an Bit Rate=54 Mb/s instead of 1Mb/s.


With rate fixed to 18MBit/s I have the same problem as with no fixed rate.

dmesg log:

phy0: Selected rate control algorithm 'pid'
phy0: hwaddr 00:15:af:03:ab:79, rtl8187 V1 + rtl8225z2
usbcore: registered new interface driver rtl8187

wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1a:92:ea:73:12
wlan0: authenticate with AP 00:1a:92:ea:73:12
wlan0: authenticate with AP 00:1a:92:ea:73:12
wlan0: authentication with AP 00:1a:92:ea:73:12 timed out

wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1a:92:ea:73:12
wlan0: RX authentication from 00:1a:92:ea:73:12 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:1a:92:ea:73:12
wlan0: RX AssocResp from 00:1a:92:ea:73:12 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: switched to short barker preamble (BSSID=00:1a:92:ea:73:12)
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

>>restarting connection with fixed rate 11M

wlan0: deauthenticate(reason=3)
ADDRCONF(NETDEV_UP): wlan0: link is not ready

wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:1a:92:ea:73:12
wlan0: RX authentication from 00:1a:92:ea:73:12 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:1a:92:ea:73:12
wlan0: RX AssocResp from 00:1a:92:ea:73:12 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: switched to short barker preamble (BSSID=00:1a:92:ea:73:12)
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present

-- 

Hauke Mehrtens
