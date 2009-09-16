Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbZIPT7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbZIPT7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbZIPT7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:59:44 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39845 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbZIPT7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:59:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZD3OwQujfpSSco6pFli9Qn5A1BFwfLirTU9JD9YE0h9UjehJ28gJw4bTsSch3Oe4fc
         TRTTGOTqixOf1nu6S0Lzvmqho1IFhICBwmbe0ZuEbti2RdDCoxW4dEuNBhFIGjZmvGV5
         D+BSk3eQ6RsY+vqTAg9LpnKkytUqAo7wHOPFY=
MIME-Version: 1.0
In-Reply-To: <1253124149.26521.438.camel@rc-desk>
References: <8db1092f0909160236i5d2b1f31k3ec289fbd9ac0bfa@mail.gmail.com>
	 <1253122055.26521.431.camel@rc-desk>
	 <8db1092f0909161036t5bae781eqa6f0a0df308ec4cd@mail.gmail.com>
	 <1253124149.26521.438.camel@rc-desk>
Date: Wed, 16 Sep 2009 21:59:43 +0200
Message-ID: <8db1092f0909161259i5e007282i42f426bc2d0fc0c4@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/scan.c:267 ieee80211_scan_completed+0x299/0x2b0 
	[mac80211]()
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/16 reinette chatre <reinette.chatre@intel.com>:
>
> You mentioned that you tried to connect to two networks. From the logs I
> can understand that the connection to the first network took a long
> time. This is also not due to the warnings you encountered (the warnings
> only showed up after you disconnected from second network). The reason
> why the connection to the first network took so long was some protocol
> exchange problems with AP. Here is the relevant information from your
> log:
>
[...]
>
> As you can see the AP keeps deauthenticating you with Reason 6. This
> means "Incorrect frame type or subtype received from unauthenticated
> station". Can you try to connect using wpa_supplicant? When you do make
> sure there is no other network managing applications (like network
> manager, wicd, or even other instances of wpa_supplicant etc) running.
>
> The connection to the second network went very fast - completed in one
> second. But a disconnection was requested locally just as fast. Do you
> perhaps have more than one network managing application running?

1. Stop wicd daemon (I don't use another application to connect to the network).
2. Connect to network "x" (with WPA)

Script (wifi_wpa.sh):
#!/bin/sh
INTERFACE=wlan0
WPA_FILE=/etc/wpa_supplicant/wpa_supplicant.conf
DRIVER=wext
ifconfig eth0 down
ifconfig $INTERFACE up
sleep 3
killall wpa_supplicant &> /dev/null
wpa_supplicant -c $WPA_FILE -D $DRIVER -i $INTERFACE -B
dhclient $INTERFACE
iwconfig $INTERFACE

File /etc/wpa_supplicant/wpa_supplicant.conf:
# WPA-PSK/TKIP

ctrl_interface=/var/run/wpa_supplicant

network={
	ssid="x"
	key_mgmt=WPA-PSK
	proto=WPA
	pairwise=TKIP
	group=TKIP
	psk=<data hidden>
	priority=4
}

First try:
root@gumis:/home/maciek# /home/maciek/bin/wifi/wifi_wpa.sh
Internet Systems Consortium DHCP Client V3.1.2p1
Copyright 2004-2009 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

Listening on LPF/wlan0/00:13:02:c3:96:a8
Sending on   LPF/wlan0/00:13:02:c3:96:a8
Sending on   Socket/fallback
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 6
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 15
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 11
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 8
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 11
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 10
No DHCPOFFERS received.
Trying recorded lease 192.168.0.102
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.

--- 192.168.0.1 ping statistics ---
1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms

No working leases in persistent database - sleeping.
wlan0     IEEE 802.11abg  ESSID:"x"
          Mode:Managed  Frequency:2.457 GHz  Access Point: 00:1B:11:F6:0F:28
          Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
	
>From dmesg:
[  256.945249] b44: eth0: powering down PHY
[  256.948714] iwl3945 0000:08:00.0: firmware: requesting
iwlwifi-3945-2.ucode
[  256.985907] iwl3945 0000:08:00.0: loaded firmware version 15.32.2.9
[  257.060922] Registered led device: iwl-phy0::radio
[  257.061021] Registered led device: iwl-phy0::assoc
[  257.061070] Registered led device: iwl-phy0::RX
[  257.061109] Registered led device: iwl-phy0::TX
[  262.899954] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  262.902445] wlan0 direct probe responded
[  262.902455] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  262.904278] wlan0: authenticated
[  262.904328] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  262.906702] wlan0: RX AssocResp from 00:1b:11:f6:0f:28 (capab=0x431
status=0 aid=1)
[  262.906711] wlan0: associated
[  266.615969] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason:
6)
[  269.342010] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  269.344434] wlan0 direct probe responded
[  269.344441] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  269.346167] wlan0: authenticated
[  269.346197] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  269.348470] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)

[...]

[  416.396624] wlan0: associated
[  419.907739] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason: 6)
[  422.633775] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  422.832075] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 2)
[  423.032068] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 3)
[  423.034477] wlan0 direct probe responded
[  423.034484] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  423.036229] wlan0: authenticated
[  423.036266] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  423.038518] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  423.038524] wlan0: associated
[  481.301801] wlan0: deauthenticating by local choice (reason=3)

Second try:
root@gumis:/home/maciek# /home/maciek/bin/wifi/wifi_wpa.sh
There is already a pid file /var/run/dhclient.pid with pid 4555
killed old client process, removed PID file
Internet Systems Consortium DHCP Client V3.1.2p1
Copyright 2004-2009 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

Listening on LPF/wlan0/00:13:02:c3:96:a8
Sending on   LPF/wlan0/00:13:02:c3:96:a8
Sending on   Socket/fallback
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 6
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 9
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 8
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 14
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 15
DHCPOFFER from 192.168.0.1
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPACK from 192.168.0.1
Reloading /etc/samba/smb.conf: smbd only.
bound to 192.168.0.102 -- renewal in 571812 seconds.
wlan0     IEEE 802.11abg  ESSID:"x"
          Mode:Managed  Frequency:2.457 GHz  Access Point: 00:1B:11:F6:0F:28
          Bit Rate=54 Mb/s   Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
          Link Quality=68/70  Signal level=-42 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
	
Dmesg:
[  481.460263] Registered led device: iwl-phy0::radio
[  481.460289] Registered led device: iwl-phy0::assoc
[  481.460375] Registered led device: iwl-phy0::RX
[  481.460396] Registered led device: iwl-phy0::TX
[  481.476399] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  481.478822] wlan0 direct probe responded
[  481.478828] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  481.480750] wlan0: authenticated
[  481.480775] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  481.483111] wlan0: RX AssocResp from 00:1b:11:f6:0f:28 (capab=0x431
status=0 aid=1)
[  481.483116] wlan0: associated
[  485.238506] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason:
6)
[  485.361103] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  485.363480] wlan0 direct probe responded
[  485.363487] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  485.365222] wlan0: authenticated
[  485.365253] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  485.367505] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  485.367512] wlan0: associated
[  489.334545] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason:
6)
[  492.052130] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  492.054555] wlan0 direct probe responded
[  492.054562] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  492.056507] wlan0: authenticated
[  492.056541] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  492.058793] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  492.058800] wlan0: associated
[  495.580873] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason:
6)
[  498.302685] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  498.305121] wlan0 direct probe responded
[  498.305129] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  498.306855] wlan0: authenticated
[  498.306885] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  498.309142] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  498.309149] wlan0: associated
[  501.520066] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason:
6)
[  504.250066] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  504.252493] wlan0 direct probe responded
[  504.252500] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  504.254227] wlan0: authenticated
[  504.254256] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  504.256525] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  504.256532] wlan0: associated
[  507.766452] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason: 6)
[  510.518231] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  510.520682] wlan0 direct probe responded
[  510.520689] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  510.522415] wlan0: authenticated
[  510.522447] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  510.524699] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  510.524706] wlan0: associated
[  514.012725] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason: 6)
[  516.718174] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  516.720611] wlan0 direct probe responded
[  516.720619] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  516.722346] wlan0: authenticated
[  516.722377] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  516.724653] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  516.724660] wlan0: associated
[  520.873494] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason: 6)
[  523.608977] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  523.611397] wlan0 direct probe responded
[  523.611405] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  523.613133] wlan0: authenticated
[  523.613165] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  523.615415] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  523.615421] wlan0: associated
[  527.011070] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason: 6)
[  529.714994] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  529.717412] wlan0 direct probe responded
[  529.717420] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  529.719146] wlan0: authenticated
[  529.719176] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  529.721458] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  529.721465] wlan0: associated

3. Connect to network "y" (without wpa/wep/etc.)
Script:
#!/bin/sh

INTERFACE="wlan0"
ESSID="y"
killall wpa_supplicant
ifconfig $INTERFACE down
iwconfig $INTERFACE essid $ESSID
ifconfig $INTERFACE up
sleep 3
killall dhclient &> /dev/null
dhclient $INTERFACE
sleep 3
iwconfig $INTERFACE

First try:
root@gumis:/home/maciek# /home/maciek/bin/wifi/wifi_dhcp.sh
There is already a pid file /var/run/dhclient.pid with pid 4819
killed old client process, removed PID file
Internet Systems Consortium DHCP Client V3.1.2p1
Copyright 2004-2009 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

Listening on LPF/wlan0/00:13:02:c3:96:a8
Sending on   LPF/wlan0/00:13:02:c3:96:a8
Sending on   Socket/fallback
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPNAK from 192.168.1.1
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 4
DHCPOFFER from 192.168.1.1
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPACK from 192.168.1.1
Reloading /etc/samba/smb.conf: smbd only.
bound to 192.168.1.102 -- renewal in 40350 seconds.
wlan0     IEEE 802.11abg  ESSID:"y"
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:0D:F3:0D:D1:4C
          Bit Rate=54 Mb/s   Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
          Link Quality=31/70  Signal level=-79 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


Dmesg:
[ 1088.324243] Registered led device: iwl-phy0::radio
[ 1088.324270] Registered led device: iwl-phy0::assoc
[ 1088.324354] Registered led device: iwl-phy0::RX
[ 1088.324374] Registered led device: iwl-phy0::TX
[ 1088.339739] wlan0: direct probe to AP 00:0d:f3:0d:d1:4c (try 1)
[ 1088.343450] wlan0 direct probe responded
[ 1088.343458] wlan0: authenticate with AP 00:0d:f3:0d:d1:4c (try 1)
[ 1088.345313] wlan0: authenticated
[ 1088.345337] wlan0: associate with AP 00:0d:f3:0d:d1:4c (try 1)
[ 1088.347943] wlan0: RX AssocResp from 00:0d:f3:0d:d1:4c (capab=0x401
status=0 aid=2)
[ 1088.347948] wlan0: associated

Normally I use wicd to manage all networks. In first e-mail I connect
to "x" and - after this - connect to "y".

Network "x" is my own network. Sometimes (if is visible) I connect to
"y" - somebody create fast network without any protection... :-)  Till
2.6.31 all works ok.

Note: in "x" and "y" I have the same IP (this only coincidence).
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
