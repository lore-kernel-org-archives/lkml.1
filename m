Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbXHKIgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbXHKIgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 04:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXHKIgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 04:36:09 -0400
Received: from pih-relay06.plus.net ([212.159.14.133]:42584 "EHLO
	pih-relay06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130AbXHKIgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 04:36:04 -0400
X-Greylist: delayed 2994 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Aug 2007 04:36:04 EDT
Date: Sat, 11 Aug 2007 08:39:59 +0100
From: Shish <shish@shishnet.org>
To: linux-kernel@vger.kernel.org
Subject: Weird network problems with 2.6.23-rc2
Message-Id: <20070811083959.305b0421.shish@shishnet.org>
Organization: ShishNet.org
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Something seems to have broken in 2.6.23-rc2, and I'm not sure what, or
where I should look for further debugging. The info I have:

On my 2.6.23-rc2 desktop, things run fine.

On my test server, built from the same source tree, networking goes
strange every few minutes, with the following symptoms:

o) running ping against the server, the first ping goes through;
further pings go AWOL until about icmp_seq=30, when I get 4-5 icmp
replies (marked as DUP!), then no pings for a while, then dups, and so
on.

o) the server doesn't see ARP replies. According to tcpdump, the server
will send eg "who has 192.168.0.2? tell 192.168.0.1"; the client in
question will recieve the packet and send a response, but nothing shows
up in the server-side tcpdump.

o) after a few minutes of random network troubles, everything will work
fine again, (ping is normal, arp replies are seen, tcp sessions work)
for a few minutes.

o) The server's dmesg shows lots of "short udp packet" messages

o) ifdown then ifup'ing the interfaces fixes things, temporarily.

Reverting to 2.6.22, everything seems to be running fine (but no lguest,
which is what I came for :( )

I've also tried with the latest code from git, the behaviour is the same
as 2.6.23-rc2.

-- 
Shish

PS. First message to the list, please don't hurt me :P
