Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZLWWso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZLWWso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbZLWWsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:48:42 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56583 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbZLWWsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:48:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DQSECk3w0zJAU6QP25nGKRfPtdUGZiyk+/494y7ZBsnMH+sv3LWO0fLuldiKhXgLP5
         E2ik353R8aFY9AN90tI+GJM5e9zl79tiATtIgajvWpJ6ShDp5IwQ6gRJvGwbiYNL6C9B
         kC1X0UcwOwwG851ITow1xBW5GGu8Z9l/ONNK0=
MIME-Version: 1.0
Date: Wed, 23 Dec 2009 22:48:39 +0000
Message-ID: <c6b1100b0912231448v759eac55kfb3dd1e6d6186c73@mail.gmail.com>
Subject: 2.6.33.rc1-git3 - regression in rt61pci driver
From: Chris Clayton <chris2553@googlemail.com>
To: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not subscribed, so please cc me on any reply.

I've built and installed today's -git kernel
(v2.6.33-rc1-225-gc9f937e) and find that my (rt61pci) wireless card no
longer works. All the usual drivers are loaded when I insert the card.
The card works fine with 2.6.32.2 (as long as I disable power saving).

The symptoms are that:

1. The file /proc/net/wireless never appears

2. iwconfig gives "wlan0     no wireless extensions."

3. ifconfig wlan0 up succeeds

4. iwconfig wlan0 essid MYSSID gives

Cannot read /proc/net/wireless
Error for wireless request "Set ESSID" (8B1A) :
    SET failed on device wlan0 ; Invalid argument.

5. ifconfig -a gives:

wlan0     Link encap:Ethernet  HWaddr 00:11:50:DE:04:F4
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

6. /proc/net/dev contains:

Inter- |   Receive
                               |  Transmit
 face |bytes    packets errs drop fifo frame compressed
multicast|bytes    packets errs drop fifo colls carrier compressed
    lo:     600      12    0    0    0     0          0         0
600      12    0    0    0     0       0          0
 wlan0:       0       0    0    0    0     0          0         0
  0       0    0    0    0     0       0          0

7. dmesg shows the following messages triggered by insertion of the card:

pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
pci 0000:03:00.0: reg 10: [mem 0xffff8000-0xffffffff]
pci 0000:03:00.0: BAR 0: assigned [mem 0xf4000000-0xf4007fff]
pci 0000:03:00.0: BAR 0: set to [mem 0xf4000000-0xf4007fff] (PCI
address [0xf4000000-0xf4007fff]
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
rt61pci 0000:03:00.0: enabling device (0000 -> 0002)
rt61pci 0000:03:00.0: PCI INT A -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
rt61pci 0000:03:00.0: setting latency timer to 64
phy0: Selected rate control algorithm 'minstrel'
Registered led device: rt61pci-phy0::radio
Registered led device: rt61pci-phy0::assoc


I'll see if I can find time for a bisect session tomorrow, but let me
know if I can supply any additional diagnostics.

Thanks

Chris

-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
