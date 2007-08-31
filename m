Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbXHaEFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbXHaEFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXHaEFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:05:12 -0400
Received: from main.gmane.org ([80.91.229.2]:53781 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbXHaEFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:05:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dan Stromberg <dstromberglists@gmail.com>
Subject: ifconfig changing a routing table?
Date: Fri, 31 Aug 2007 03:55:53 +0000 (UTC)
Message-ID: <fb83g8$nac$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-106-77.dsl.irvnca.pacbell.net
X-Face: 7muj=^NJ4z|eE'nj&_M\3zqbh(dwtkA%Z{^'Cou0AFC9&[@R4!mMClzF!j0ZN|`7h/F1`Kgr$a[j^R+H:4DD}ra;@^Z7uIoqYRc\elYJ{)(sSy@%|eX\0WRNDj"W3rh{5%/ZQwnxeqA\({gn7O+7MF`"Tdl:.5U-{8n+OOjJo7(krf!d|tOMnmm"7MLYAwm':OjvlO|`\)N!q.ICnDJIMHv<j~'<i78LXT-cPluto:1-5?*=li=k1AY9"n~lMm.PSZiVf/UbMxH}OCQsE$`MO~gRn`=~%)bIP,^'R]g=L,^ot
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If I "ifconfig eth1 down", a rogue route disappears.

If I "ifconfig eth1 up" or "ip link set dev eth1 up", the rogue route 
comes back.

The route in question is for 10.3/16, and it's breaking some of my 
communications that should be handled by my default route.

I'm not accustomed to ifconfig changing the routing table.  Is this 
normal?

The kernel in question is 2.6.9-42.0.8.plus.c4smp.  It's a CentOSplus 
kernel.

The relevant syscalls in an strace of the above ip link command (which a 
very short strace, BTW) appear to be:

9992  socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
9992  ioctl(3, SIOCGIFFLAGS, {ifr_name="eth1", ifr_flags=IFF_BROADCAST|
IFF_MULTICAST}) = 0
9992  ioctl(3, SIOCSIFFLAGS, 0x7fbffff510) = 0
9992  close(3)                          = 0

The strace of ifconfig eth1 up is pretty similar, albeit with a slightly 
different 3rd argument to the SIOCSIFFLAGS.

I tracked the call chain to dev_change_flags(), but then things seemed to 
start branching out pretty fast, so I thought it might be more productive 
to ask around before continuing.

Is anyone on the list familiar with ifconfig up and/or ip link up 
changing a routing table?  How does the kernel decide what route to add 
in such a circumstance?

Thanks!


