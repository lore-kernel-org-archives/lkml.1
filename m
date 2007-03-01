Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXCAN1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXCAN1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXCAN1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:27:51 -0500
Received: from web52902.mail.yahoo.com ([206.190.49.12]:43950 "HELO
	web52902.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965034AbXCAN1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:27:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=nce27yiUcCZrer5xEUMIW2LONUKDsseRBw4PnIB2a6j6z4X6bntaGAqywHctpo6if97PQqvcsvOAi6XiRogrs354ZKkTSYZh3AitkBTOSd7s3LVaIlgXjrSIMysC5XI5x/BF3xWQNHxRCKwg0f6+xPzq8Yjs00bpuFF348hnzcM=;
X-YMail-OSG: h4JyuAkVM1ki1Vm9HiXnzGGN5Tc91f3Wh_uhcIVFkR7sTBbP5OKJuM1udxj..8coVzhh71wn9dRYtWisecmcgo73TYbHFV6bvj_sqKLXKPAoJsOTR4vewNiLPxTIsMzRwnlCgzqeSdpLci9HNTqm8Ias
Date: Thu, 1 Mar 2007 13:27:49 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.1 - unable to handle kernel paging request - accessing freed memory?
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703011330330.29829@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <700199.70204.qm@web52902.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh yes - I'd better mention what my Ethernet devices are:

$ cat /proc/net/dev
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo
colls carrier compressed
    lo:  820705   15570    0    0    0     0          0         0   820705   15570    0    0    0 
   0       0          0
  eth0: 3289077   14258    0    0    0     0          0       639  1379700   14175    0    0    0 
   0       0          0
  eth1:       0       0    0    0    0     0          0         0        0  0    0    0    0     0
      0          0
  eth2:       0       0    0    0    0     0          0         0        0  0    0    0    0     0
      0          0


$ /sbin/ifconfig
eth0      Link encap:Ethernet  HWaddr 00:0D:56:0D:E7:3F
          inet addr:192.168.0.3  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::20d:56ff:fe0d:e73f/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:14262 errors:0 dropped:0 overruns:0 frame:0
          TX packets:14175 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100
          RX bytes:3289533 (3.1 MiB)  TX bytes:1379700 (1.3 MiB)
          Base address:0xdcc0 Memory:ff6e0000-ff700000

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:15570 errors:0 dropped:0 overruns:0 frame:0
          TX packets:15570 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:820705 (801.4 KiB)  TX bytes:820705 (801.4 KiB)

# /sbin/ifconfig eth1
eth1      Link encap:UNSPEC  HWaddr 87-FF-FF-FF-FF-FF-FF-00-00-00-00-00-00-00-00-00
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

# /sbin/ifconfig eth2
eth2      Link encap:UNSPEC  HWaddr 00-02-3C-00-A1-03-71-11-00-00-00-00-00-00-00-00
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

I think that eth1 and eth2 are both "eth1394" devices, automatically loaded on the two Firewire
"hubs"(?) in this machine?

Cheers,
Chris



		
___________________________________________________________ 
All New Yahoo! Mail – Tired of unwanted email come-ons? Let our SpamGuard protect you. http://uk.docs.yahoo.com/nowyoucan.html
