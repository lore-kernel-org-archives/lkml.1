Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbYLHHep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbYLHHep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 02:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYLHHeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 02:34:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:58738 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYLHHeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 02:34:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wBtx0v4pKd/lyaxDSb8ia41aAtI56z9ZhUp4PQIlOphTLLAcwhpXJHRmeUAX5+WU3X
         sVvr0FjaQV7n1Vzva7gTDjXNRoBT9h4I/xjjcJhB3wgJ1q6UiH2yOXdgeA1cRcfTo033
         C+dqOQN48VLQUE6sZqDRMyQPT8/f1X4WuxRB0=
Message-ID: <2aac3c260812072334v5d85ca2cke6cd33d7c912b8ea@mail.gmail.com>
Date: Mon, 8 Dec 2008 08:34:03 +0100
From: "Giangiacomo Mariotti" <giangiacomo.mariotti@gmail.com>
To: "Shaya Potter" <spotter@yucs.org>
Subject: Re: weird realtek gigabit ethernet issue
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <493CB716.8070300@yucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <493CB716.8070300@yucs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mB87Yndq008905

On Mon, Dec 8, 2008 at 6:56 AM, Shaya Potter <spotter@yucs.org> wrote:> [please cc me in any response as not subscribed]>> I have an Asus M3A78-EM motherboard with a "Realtek Semiconductor Co.,> Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)"> (per lspci)>> which is using the r8169 module on ubuntu intrepid (specifically ubuntu> kernel 2.6.27-9-generic)>> kernel reports>> RTL8168c/8111c at 0xf88be000, 00:22:15:a1:d2:41, XID 3c4000c0 IRQ 222>> well, what's the issue, its going crazy on the dropped packets, even> when the only thing connected to it is is an ssh session.>> namely ifconfig shows>> eth0 Link encap:Ethernet HWaddr 00:22:15:a1:d2:41> inet addr:192.168.0.41 Bcast:192.168.0.255 Mask:255.255.255.0> inet6 addr: fe80::222:15ff:fea1:d241/64 Scope:Link> UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1> RX packets:499 errors:0 dropped:2867537736 overruns:0 frame:0> TX packets:538 errors:0 dropped:0 overruns:0 carrier:0> collisions:0 txqueuelen:1000> RX bytes:38995 (38.9 KB) TX bytes:87571 (87.5 KB)> Interrupt:222 Base address:0xe000>> and the dropped count keeps on cycling through its entire space rapidly.>> it's running in gigabit mode>> root@nas:/home/spotter# mii-tool> eth0: negotiated 1000baseT-FD flow-control, link ok>> I have no idea why.  never seen anything like this before.  been> wondering what could be doing it.>> in investigating the driver>> /*>  * The driver does not support incoming fragmented>  * frames. They are seen as a symptom of over-mtu>  * sized frames.>  */> if (unlikely(rtl8169_fragmented_frame(status))) {>        dev->stats.rx_dropped++;>        dev->stats.rx_length_errors++;>        rtl8169_mark_to_asic(desc, tp->rx_buf_sz);>        continue;> }>> so it would appear to be some issue relating to fragmented frames.>> However, based on the amount of packets received, it seems to be very> strange.>> I would have thought maybe it had something to do with jumbo packets,> but all the machines on the net are using an mtu of 1500 currently.>> anyways, any explanation, if its not a bug, would be appreciated.> --> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html> Please read the FAQ at  http://www.tux.org/lkml/>Did you try using iproute2 instead of ifconfig? I have the sameproblem with ifconfig, but iproute says that there's no problem:ifconfig :
eth0      Link encap:Ethernet  HWaddr 00:1f:d0:ae:41:0e          inet addr:192.168.1.3  Bcast:192.168.1.255  Mask:255.255.255.0          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1          RX packets:16100 errors:0 dropped:152365729778 overruns:0 frame:0          TX packets:15465 errors:0 dropped:0 overruns:0 carrier:0          collisions:0 txqueuelen:1000          RX bytes:15693968 (14.9 MiB)  TX bytes:2565833 (2.4 MiB)          Interrupt:245 Base address:0xc000
ip -stats link show eth0 :
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_faststate UNKNOWN qlen 1000    link/ether 00:1f:d0:ae:41:0e brd ff:ff:ff:ff:ff:ff    RX: bytes  packets  errors  dropped overrun mcast    15677088   16028    0       0       0       0    TX: bytes  packets  errors  dropped carrier collsns    2536480    15384    0       0       0       0


-- You highest men whom my eyes have seen, this is my doubt about you andmy secret laughter: I guess that you would call my overmanâ€”devil!What is great is so alien to your souls that the overman would beterrifying to you in his goodness ...ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
