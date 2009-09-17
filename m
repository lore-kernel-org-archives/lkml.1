Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZIQGcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZIQGcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 02:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZIQGce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 02:32:34 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:59235 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbZIQGca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 02:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Vc0FyRzPRrRKDPP15iyrO1ZDCkJafeunRPLuy99/n+K0umiabcTcz5LYlRz0OtlCIu
         salsjzXI3kmkjFPO6js9qgb3HgKu6JG7+AgpuH1nkwCJkoLkBI+/DKOSJVbdXopUgtq+
         VHCSnSwedyE9bTPGonvPa48w7Pzp9ansxHEX4=
MIME-Version: 1.0
In-Reply-To: <1253139186.26521.449.camel@rc-desk>
References: <8db1092f0909160236i5d2b1f31k3ec289fbd9ac0bfa@mail.gmail.com>
	 <1253122055.26521.431.camel@rc-desk>
	 <8db1092f0909161036t5bae781eqa6f0a0df308ec4cd@mail.gmail.com>
	 <1253124149.26521.438.camel@rc-desk>
	 <8db1092f0909161259i5e007282i42f426bc2d0fc0c4@mail.gmail.com>
	 <1253139186.26521.449.camel@rc-desk>
Date: Thu, 17 Sep 2009 08:32:33 +0200
Message-ID: <8db1092f0909162332r4ffeef09jdb87f7fc69ff8e9e@mail.gmail.com>
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

2009/9/17 reinette chatre <reinette.chatre@intel.com>:
[...]
>
> I think there is a potential race here. You start wpa_supplicant in
> background and then immediately request an IP. It is not guaranteed at
> this point that you are associated.
>
> Could you perform the last three steps of your script manually?
>
> Reinette
>
>
>

root@gumis:/home/maciek# INTERFACE=wlan0
root@gumis:/home/maciek# WPA_FILE=/etc/wpa_supplicant/wpa_supplicant.conf
root@gumis:/home/maciek# DRIVER=wext
root@gumis:/home/maciek# ifconfig eth0 down
root@gumis:/home/maciek# killall dhclient3

Dmesg:
[  130.925689] b44: eth0: powering down PHY

root@gumis:/home/maciek# ifconfig $INTERFACE up

Demsg:
[  171.563937] iwl3945 0000:08:00.0: firmware: requesting iwlwifi-3945-2.ucode
[  171.611178] iwl3945 0000:08:00.0: loaded firmware version 15.32.2.9
[  171.688664] Registered led device: iwl-phy0::radio
[  171.688759] Registered led device: iwl-phy0::assoc
[  171.688802] Registered led device: iwl-phy0::RX
[  171.688844] Registered led device: iwl-phy0::TX

root@gumis:/home/maciek# killall wpa_supplicant &> /dev/null
(wait 5 seconds)
root@gumis:/home/maciek# wpa_supplicant -c $WPA_FILE -D $DRIVER -i $INTERFACE -B
(and wait)

Dmesg:
[  249.340094] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  249.345339] wlan0 direct probe responded
[  249.345347] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  249.347122] wlan0: authenticated
[  249.347152] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  249.349703] wlan0: RX AssocResp from 00:1b:11:f6:0f:28 (capab=0x431
status=0 aid=1)
[  249.349711] wlan0: associated
[  253.411858] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason:
6)
[  256.116488] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  256.118910] wlan0 direct probe responded
[  256.118918] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  256.120663] wlan0: authenticated
[  256.120694] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  256.122944] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  256.122951] wlan0: associated

[...]

[  353.353780] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason: 6)
[  356.070680] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  356.073112] wlan0 direct probe responded
[  356.073121] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  356.074849] wlan0: authenticated
[  356.074879] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  356.077160] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  356.077168] wlan0: associated


(Stop wainting)
root@gumis:/home/maciek# dhclient $INTERFACE
Internet Systems Consortium DHCP Client V3.1.2p1
Copyright 2004-2009 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

Listening on LPF/wlan0/00:13:02:c3:96:a8
Sending on   LPF/wlan0/00:13:02:c3:96:a8
Sending on   Socket/fallback
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 4
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 11
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 11
DHCPOFFER from 192.168.0.1
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPACK from 192.168.0.1
Reloading /etc/samba/smb.conf: smbd only.
bound to 192.168.0.102 -- renewal in 474672 seconds.

Dmesg:
[  390.228036] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason:
6)
[  392.969750] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  392.972333] wlan0 direct probe responded
[  392.972342] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  392.974072] wlan0: authenticated

[...]

[  425.722523] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  425.724773] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  425.724782] wlan0: associated
[  429.231829] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason: 6)
[  431.936205] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  431.938624] wlan0 direct probe responded
[  431.938631] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  431.940470] wlan0: authenticated
[  431.940502] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  431.942754] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28
(capab=0x431 status=0 aid=1)
[  431.942761] wlan0: associated

root@gumis:/home/maciek# iwconfig $INTERFACE
wlan0     IEEE 802.11abg  ESSID:"x"
          Mode:Managed  Frequency:2.457 GHz  Access Point: 00:1B:11:F6:0F:28
          Bit Rate=54 Mb/s   Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
          Link Quality=53/70  Signal level=-57 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

root@gumis:/home/maciek# ping onet.pl
PING onet.pl (213.180.146.27) 56(84) bytes of data.
64 bytes from s4.m1r2.onet.pl (213.180.146.27): icmp_seq=1 ttl=53 time=18.3 ms
64 bytes from s4.m1r2.onet.pl (213.180.146.27): icmp_seq=2 ttl=53 time=21.0 ms
^C
--- onet.pl ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 18.395/19.702/21.009/1.307 ms

===============================

Compare to 2.6.31:
root@gumis:/home/maciek# /home/maciek/bin/wifi/wifi_wpa.sh
Internet Systems Consortium DHCP Client V3.1.2p1
Copyright 2004-2009 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

Listening on LPF/wlan0/00:13:02:c3:96:a8
Sending on   LPF/wlan0/00:13:02:c3:96:a8
Sending on   Socket/fallback
DHCPREQUEST on wlan0 to 255.255.255.255 port 67
DHCPACK from 192.168.0.1
Reloading /etc/samba/smb.conf: smbd only.
bound to 192.168.0.102 -- renewal in 596714 seconds.
wlan0     IEEE 802.11abg  ESSID:"x"
          Mode:Managed  Frequency:2.457 GHz  Access Point: 00:1B:11:F6:0F:28
          Bit Rate=1 Mb/s   Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption
key:D99A-9047-D4B3-05CD-5AD4-041C-A1A1-577D-CF2C-7BC4-1F49-08F8-9802-2A2D-F5B3-0861
[2]
          Power Management:off
          Link Quality=50/70  Signal level=-60 dBm  Noise level=-127 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Demsg:	
[   92.188241] b44: eth0: powering down PHY
[   92.191643] iwl3945 0000:08:00.0: firmware: requesting iwlwifi-3945-2.ucode
[   92.305225] iwl3945 0000:08:00.0: loaded firmware version 15.32.2.9
[   92.380738] Registered led device: iwl-phy0::radio
[   92.381651] Registered led device: iwl-phy0::assoc
[   92.381685] Registered led device: iwl-phy0::RX
[   92.381708] Registered led device: iwl-phy0::TX
[   98.353640] wlan0: authenticate with AP 00:1b:11:f6:0f:28
[   98.355401] wlan0: authenticated
[   98.355407] wlan0: associate with AP 00:1b:11:f6:0f:28
[   98.357622] wlan0: RX AssocResp from 00:1b:11:f6:0f:28 (capab=0x431
status=0 aid=1)
[   98.357630] wlan0: associated


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
