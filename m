Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbYBGOYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbYBGOYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYBGOXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:23:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:30857 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbYBGOXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:23:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FDPbYQT132QR/imooRTj0E4yEVjNOgYSEYF9uSZ68SMYpPHeUjx5lm/Phiis444QFvSVs5LGMgrqCKhjiT7g1lOPesFvS6eYCTvb/Wh21xoBFtWR9zv+6HeJ9CU7/LTb21b59svBKFqO09w4ccnfVSPaPPB1b0bPxdFzdJJ2GJk=
Message-ID: <6101e8c40802070623t55115dc3h4cf508e432b9296f@mail.gmail.com>
Date: Thu, 7 Feb 2008 15:23:49 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Marcin Koziej" <marcinkoziej@o2.pl>
Subject: Re: Bug? Kernels 2.6.2x drops TCP packets over wireless (independent of card used)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <56de948.2f1b076b.47aac980.bfd66@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <56de948.2f1b076b.47aac980.bfd66@o2.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hmm, i think, the site is broken (193.219.28.140), and not the card or
the driver is wrong. when it does, then other sites are auch
reproductable ..

/* is use auch madwifi-0.9.3.3, but it think, it is not driver problem */

On 2/7/08, Marcin Koziej <marcinkoziej@o2.pl> wrote:
>
> Hello, I have problem with wireless network connectivity;
> I have tested this on two wireless cards, both giving same results:
> These are:
> 1) 02:00.0 Ethernet controller: Atheros Communications, Inc. AR5212
> 802.11abg NIC (rev 01)
> working under madwifi-0.9.3.3
> 2) 00:0a.0 Ethernet controller: Linksys, A Division of Cisco Systems
> [AirConn] INPROCOMM IPN 2220 Wireless LAN Adapter (rev 01)
> working under ndiswrapper on neti2220 driver
>
> On kernel 2.6.19 both cards are working fine (with same network
> configuration)
>
> Problems arise on kernels 2.6.2x, information below is from 2.6.23, but
> 2.6.24-rc8-git7 also was tested:
> Both cards can associate with ap, and get TCP/IP configuration from the
> router.
> Both cards can ping the router (0% packet loss), resolve hostnames using DNS
> (suggesting UDP is working fine).
> However, when any kind of TCP connection is made, it hangs after initial
> handshake and maybe some ammount of data interchanged. This is checked by
> tcpdump provided below.
>
> This happens every time to all tcp connections.
>
> Example with Atheros card:
> ath0      IEEE 802.11g  ESSID:"hotspot"  Nickname:""
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:60:B3:6C:A1:2E
>
>           Bit Rate:11 Mb/s   Tx-Power:17 dBm   Sensitivity=1/1
>           Retry:off   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=19/70  Signal level=-77 dBm  Noise level=-96 dBm
>           Rx invalid nwid:43882  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
>
> # ftp ftp.icm.edu.pl
> Connected to ftp.icm.edu.pl (193.219.28.140).
> 220-
> (hangs)
>
> The packet dump is:
> 23:56:08.807674 IP 192.168.1.2.51909 > sunsite2.icm.edu.pl.ftp: S
> 980196671:980196671(0) win 5840 <mss 1460,sackOK,timestamp 1971553
> 0,nop,wscale 5>
> 	0x0000:  4500 003c 885e 4000 4006 124c c0a8 0102  E..<.^@.@..L....
> 	0x0010:  c1db 1c8c cac5 0015 3a6c 9d3f 0000 0000  ........:l.?....
> 	0x0020:  a002 16d0 d91a 0000 0204 05b4 0402 080a  ................
> 	0x0030:  001e 1561 0000 0000 0103 0305            ...a........
> 23:56:08.821639 IP sunsite2.icm.edu.pl.ftp > 192.168.1.2.51909: S
> 2723526584:2723526584(0) ack 980196672 win 5792 <mss 1460,sackOK,timestamp
> 983901832 1971553,nop,wscale 7>
> 	0x0000:  4500 003c 0000 4000 3c06 9eaa c1db 1c8c  E..<..@.<.......
> 	0x0010:  c0a8 0102 0015 cac5 a255 b7b8 3a6c 9d40  .........U..:l.@
> 	0x0020:  a012 16a0 1dfc 0000 0204 05b4 0402 080a  ................
> 	0x0030:  3aa5 2688 001e 1561 0103 0307            :.&....a....
> 23:56:08.821685 IP 192.168.1.2.51909 > sunsite2.icm.edu.pl.ftp: . ack 1 win
> 183
> <nop,nop,timestamp 1971567 983901832>
> 	0x0000:  4500 0034 885f 4000 4006 1253 c0a8 0102  E..4._@.@..S....
> 	0x0010:  c1db 1c8c cac5 0015 3a6c 9d40 a255 b7b9  ........:l.@.U..
> 	0x0020:  8010 00b7 62a3 0000 0101 080a 001e 156f  ....b..........o
> 	0x0030:  3aa5 2688                                :.&.
> 23:56:08.842801 IP sunsite2.icm.edu.pl.ftp > 192.168.1.2.51909: P 1:7(6) ack
> 1
> win 46 <nop,nop,timestamp 983901837 1971567>
> 	0x0000:  4510 003a 9135 4000 3c06 0d67 c1db 1c8c  E..:.5@.<..g....
> 	0x0010:  c0a8 0102 0015 cac5 a255 b7b9 3a6c 9d40  .........U..:l.@
> 	0x0020:  8018 002e f3af 0000 0101 080a 3aa5 268d  ............:.&.
> 	0x0030:  001e 156f 3232 302d 0d0a                 ...o220-..
> 23:56:08.843069 IP 192.168.1.2.51909 > sunsite2.icm.edu.pl.ftp: . ack 7 win
> 183
> <nop,nop,timestamp 1971588 983901837>
> 	0x0000:  4510 0034 8860 4000 4006 1242 c0a8 0102  E..4.`@.@..B....
> 	0x0010:  c1db 1c8c cac5 0015 3a6c 9d40 a255 b7bf  ........:l.@.U..
> 	0x0020:  8010 00b7 6283 0000 0101 080a 001e 1584  ....b...........
> 	0x0030:  3aa5 268d                                :.&.
> 23:56:31.920327 IP 192.168.1.2.51909 > sunsite2.icm.edu.pl.ftp: F 1:1(0) ack
> 7
> win 183 <nop,nop,timestamp 1994676 983901837>
> 	0x0000:  4510 0034 8861 4000 4006 1241 c0a8 0102  E..4.a@.@..A....
> 	0x0010:  c1db 1c8c cac5 0015 3a6c 9d40 a255 b7bf  ........:l.@.U..
> 	0x0020:  8011 00b7 0852 0000 0101 080a 001e 6fb4  .....R........o.
> 	0x0030:  3aa5 268d                                :.&.
> 23:56:31.935145 IP sunsite2.icm.edu.pl.ftp > 192.168.1.2.51909: . ack 2 win
> 46
> <nop,nop,timestamp 983907613 1994676>
> 	0x0000:  4510 0034 913d 4000 3c06 0d65 c1db 1c8c  E..4.=@.<..e....
> 	0x0010:  c0a8 0102 0015 cac5 a255 b8e5 3a6c 9d41  .........U..:l.A
> 	0x0020:  8010 002e f124 0000 0101 080a 3aa5 3d1d  .....$......:.=.
> 	0x0030:  001e 6fb4                                ..o.
> (no more packets)
>
>
> System:
> I am using  Atheros Communications, Inc. AR5212 802.11abg NIC PCMCIA card.
> Computer is notebook, Acer Aspire 1520.
>
> I use vanilla kernel:
> Linux 2.6.23 #1 Sat Jan 12 12:07:39 CET 2008 i686 AMD Athlon(tm) 64
> Processor
> 3700+ AuthenticAMD GNU/Linux
> and madwifi driver ath_pci 0.9.4.5 (0.9.3.3)
> kernel options: irqpoll (without irqpoll system doesn't detect pcmcia
> cards).
>
> Device detection:
> ath_hal: module license 'Proprietary' taints kernel.
> ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
> ath_pci: 0.9.4.5 (0.9.3.3)
> ath_rate_sample: 1.2 (0.9.3.3)
> wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
> wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps
> 24Mbps
> 36Mbps 48Mbps 54Mbps
> wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> wifi0: H/W encryption support: WEP AES AES_CCM TKIP
> wifi0: mac 5.9 phy 4.3 radio 4.6
> wifi0: Use hw queue 1 for WME_AC_BE traffic
> wifi0: Use hw queue 0 for WME_AC_BK traffic
> wifi0: Use hw queue 2 for WME_AC_VI traffic
> wifi0: Use hw queue 3 for WME_AC_VO traffic
> wifi0: Use hw queue 8 for CAB traffic
> wifi0: Use hw queue 9 for beacons
> wifi0: Atheros 5212: mem=0x34000000, irq=11
>
> On the same irq are:
> ehci_hcd:usb1
> eth0
> uhci_hcd:usb4
> wifi%d
> yenta
>
> Please CC me in reply, since I'm not subscribed to the list.
> If more debug information is needed please don't hesitate to ask.
>
> Best regards,
> Marcin Koziej
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
