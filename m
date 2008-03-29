Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbYC2BA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbYC2BA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 21:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYC2BAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 21:00:21 -0400
Received: from compunauta.com ([69.36.170.169]:36156 "EHLO compunauta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbYC2BAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 21:00:20 -0400
X-Greylist: delayed 1898 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2008 21:00:20 EDT
From: Gustavo Guillermo =?iso-8859-1?q?P=E9rez?= 
	<gustavo@compunauta.com>
Organization: www.compunauta.com
To: linux-kernel@vger.kernel.org
Subject: tulip driver receive but not send 2.6.25-rc6-git7
Date: Fri, 28 Mar 2008 18:28:39 -0600
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803281828.39948.gustavo@compunauta.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm putting all wires on the same swirch for testing.
eth0 is a sis embedded card (good one).
dealing with dhcp I see that request arrives to the board but the offers never 
appears on client. system clean no iptables rules, just dhcpd.

00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI Fast 
Ethernet (rev 91)
00:09.0 Ethernet controller: Davicom Semiconductor, Inc. 21x4x DEC-Tulip 
compatible 10/100 Ethernet (rev 40)
00:0a.0 Ethernet controller: Davicom Semiconductor, Inc. 21x4x DEC-Tulip 
compatible 10/100 Ethernet (rev 40)

uLinuxIV ~ # ifconfig eth0 192.168.3.1
uLinuxIV ~ # ping -c 1 192.168.3.3
PING 192.168.3.3 (192.168.3.3) 56(84) bytes of data.
64 bytes from 192.168.3.3: icmp_seq=1 ttl=64 time=1.14 ms

--- 192.168.3.3 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 1.141/1.141/1.141/0.000 ms
uLinuxIV ~ # ifconfig eth0 down
uLinuxIV ~ # modprobe tulip
uLinuxIV ~ # dmesg | tail -n 10
Linux Tulip driver version 1.1.15 (Feb 27, 2007)
tulip0:  MII transceiver #1 config 1000 status 782d advertising 01e1.
eth1: Davicom DM9102/DM9102A rev 64 at Port 0xe400, 00:60:6e:70:1f:b1, IRQ 17.
tulip1:  MII transceiver #1 config 1000 status 782d advertising 01e1.
eth2: Davicom DM9102/DM9102A rev 64 at Port 0xe800, 00:60:6e:70:1f:d5, IRQ 18.
uLinuxIV ~ # ifconfig eth1 192.168.3.1
uLinuxIV ~ # ping -c 1 192.168.3.3
PING 192.168.3.3 (192.168.3.3) 56(84) bytes of data.
Aborted
uLinuxIV ~ # ifconfig eth1 down
uLinuxIV ~ # ifconfig eth2 192.168.3.1
uLinuxIV ~ # ping -c 1 192.168.3.3
PING 192.168.3.3 (192.168.3.3) 56(84) bytes of data.
Aborted
uLinuxIV ~ #

I'm gonna try with rc7-git4 and 2.6.24
-- 
Gustavo Guillermo Pérez
Compunauta uLinux
www.compunauta.com
