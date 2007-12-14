Return-Path: <linux-kernel-owner+w=401wt.eu-S935099AbXLNCJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935099AbXLNCJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 21:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763276AbXLNCJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 21:09:46 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:63893 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762927AbXLNCJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 21:09:45 -0500
Message-ID: <4761E5D6.7040801@lwfinger.net>
Date: Thu, 13 Dec 2007 18:09:26 -0800
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Ray Lee <ray-lk@madrabbit.org>, Daniel Walker <dwalker@mvista.com>,
       matthias.kaehlcke@gmail.com, mbuesch@freenet.de,
       linux-kernel@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
       linux@bohmer.net, kjwinchester@gmail.com, jonathan@jonmasters.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
 to	mutex
References: <20071213003028.676998182@mvista.com>	<200712131445.39770.mb@bu3sch.de>	<2c0942db0712131604m41c34da9hf3122b0603f3af96@mail.gmail.com> <200712140143.16451.mb@bu3sch.de>
In-Reply-To: <200712140143.16451.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Friday 14 December 2007 01:05:00 Ray Lee wrote:
>> Okay, I had to modprobe rfkill-input and rfkill by hand, didn't
>> realize that. Hopefully that'll be automatic soon. Regardless, upon
>> doing so, and loading ssb and b43, it sees my card, but is still not
>> fully functional. iwconfig sees:
>>
>> lo        no wireless extensions.
>> eth0      no wireless extensions.
>> tun0      no wireless extensions.
>> eth1      no wireless extensions.
>> wlan0_rename  IEEE 802.11g  ESSID:""
>>           Mode:Managed  Channel:0  Access Point: Not-Associated
>>           Tx-Power=0 dBm
>>           Retry min limit:7   RTS thr:off   Fragment thr=2346 B
>>           Link Quality:0  Signal level:0  Noise level:0
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>
>> (eth0 is ethernet, eth1 doesn't exist -- usually it's the wireless.)
>>
>> `ifconfig` doesn't see eth1 or wlan0_rename.
>>
>> What else might I be doing wrong?

Your udev rules are screwed up. In /etc/udev/rules.d/70-persistent-net.rules, you should have a line 
that looks like

SUBSYSTEM=="net", DRIVERS=="?*", ATTR{address}=="00:1a:73:6b:28:5a", ATTR{type}=="1", NAME="eth1"

with the MAC address for your device. You probably have the ATTR{type}=="1" clause missing.

Larry
