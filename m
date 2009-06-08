Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZFHSFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZFHSFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZFHSFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:05:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:63782 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZFHSFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=c6vf/F0SQHXFdUkgb5Ber4Nhj2qK89xJLKStGnoHkyec1fKiQyy4Hqg4H6DiYna7Fl
         hkcPO3sXOu1szl2i7uVv+KOBJ0WO2uRT0ILmknFsJa07YQv1ejKbcgm1CiJzpycsvngg
         Plb8/7Idy5I75YXDlWzm/eUWL54+C3UxU3pVM=
MIME-Version: 1.0
Date: Mon, 8 Jun 2009 21:05:25 +0300
Message-ID: <91ac27070906081105x30171bedra10d244d382a6934@mail.gmail.com>
Subject: SOCK_RAW does not receive broadcast (with VLAN unless PROMISC)
From: Gil Beniamini <gil.beniamini@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux Experts,

My application is using PF_PACKET and SOCK_RAW in order to receive all
Ethernet packets for the machine-unicast MAC plus all broadcast
packets (like ARP broadcast).

That worked OK with kernel 2.6.20 (Ubuntu 7.04 with or without VLAN).

Now with kernel 2.6.28 (Ubuntu 9.04) it works OK only without-VLAN,
but with VLAN the application receive only packets for the
machine-unicast MAC, but no broadcast (like ARP broadcast) packets,
only if I set the socket to PROMISC mode, I start receive also
broadcast packets.

To me it seems a bug, as SOCK_RAW should pass all ‘received’ packet
(including broadcast) to the application, without the need for PROMISC
(which cause my machine to receive other machine unicast  packets, and
filter those by software)!

The original application:

sock=socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
memset((char *) &sockad, 0, sizeof(sockad));
sockad.sll_family = PF_PACKET;
sockad.sll_protocol = htons(ETH_P_ALL);
sockad.sll_ifindex = ethreq.ifr_ifindex;//the relevant unit number



Now the workaround is to set (unwanted) PROMISC mode:

ioctl(sock,SIOCGIFFLAGS,&ethreq);
ethreq.ifr_flags|=IFF_PROMISC; // why does 9.04 need this (+0x100) at
least once?!
ioctl(sock,SIOCSIFFLAGS,&ethreq);


Many thanks in advance,
Gil Beniamini
gil.beniamini@gmail.com
