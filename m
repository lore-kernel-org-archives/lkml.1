Return-Path: <linux-kernel-owner+w=401wt.eu-S1031283AbXECU0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031283AbXECU0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031288AbXECU0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:26:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:59588 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031283AbXECUZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:25:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JiORAsWjqYHb8vFFw9slv8upa6cCZMVEkbD5UoeXBS/yGVWBUAw4nqe0y/uG1ycW/VOqxfNb+LDZhu3UYdgfoKrL1pO4b+VRtvAYcDBCu5slDLJeGAhapxwqJs3YNwzCZNYxZcayCPzwNHcU6AFCzOH9Ns7CJaUWuiLuzcqX3rw=
Message-ID: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com>
Date: Thu, 3 May 2007 22:25:48 +0200
From: "=?ISO-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?=" <lorrides@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Routing 600+ vlan's via linux problems (looks like arp problems)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have a one gigabit internet connection that is normally
routed by a hardware juniper router. The drive in this is down
and we need to use a linux machine (Pentium D 3 ghz) as a
temporary router.
Now setting up all the 600 vlans and assigning ip addresses
is no problem. We have testet all by using a laptop, setting up
600 vlan interfaces on this and running dhcpclient on all.
This worked just fine, all the interfaces got address.

Now for the real setup.
We closed the mac of the juniper to the network card that
would be connected to the internal LAN, set up the interfaces,
and swapped cables. This worked fine for approximately 100
of the computers that are connected, but the rest would not
get IP. The connected 100 computers were routed just fine.

What we think the problem is, is that the arp cache on the
linux router seems strange. It can resolve the MAC for the
100 clients that actually got through.
For the rest all we see in the arp cache is (incomplete)

Here is some of the listing for arp -n:
193.239.155.118          ether   00:0A:E4:59:75:66   C
eth1.1087
193.239.154.74                   (incomplete)
eth1.1016
193.239.155.7            ether   00:11:95:D2:3F:FD   C
eth1.2002
83.143.114.222                   (incomplete)
eth1.1305
83.143.113.246           ether   00:0B:5D:4B:B8:77   C
eth1.1247
83.143.116.126                   (incomplete)
eth1.1409
83.143.118.114                   (incomplete)
eth1.1534
193.239.154.210          ether   00:03:0D:2F:1B:7F   C
eth1.1050
169.254.69.247           ether   00:15:C5:C2:31:6C   C
eth1.1262
83.143.112.38                    (incomplete)
eth1.1131
83.143.118.18                    (incomplete)
eth1.1510
83.143.112.118           ether   00:11:95:CE:BF:72   C
eth1.1151
192.168.1.2              ether   00:0D:88:78:C0:00   C
eth1.2050
83.143.117.138                   (incomplete)
eth1.1476
83.143.116.18                    (incomplete)
eth1.1382
83.143.118.26                    (incomplete)
eth1.1512
83.143.112.6                     (incomplete)
eth1.1123
193.239.155.62                   (incomplete)
eth1.1073

`arp -n|wc -l` returns around 350, which is the number of active ports on the
edge switches...
this number is confirmed by snmp

I have looked through the source for arp.c but i can't see any immediate
problems. There is no messages in dmesg, kern.log og messages (except for
eth1.vlanid up * 600).

If anyone know what the problem can be, if this is a bug, or if PSBKC i would
much appreciate it.

regards
Øyvind Vågen Jægtnes
+47 96 22 03 08
lorrides@gmail.com
