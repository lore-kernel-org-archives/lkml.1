Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZBFInh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZBFInh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZBFIn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:43:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:16589 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZBFIn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:43:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=cFIXmH3aAZVY3lCNlerTUHwjej0qIxwqPNDZMOJUqRz6v7g4YOqQdBps1DRoPU8Vsa
         REqeFHQynlJPB1fTCLE5fOPWiw97eZXf/T+s94HyiNRcWOFGZsaq7RahDRtGy6L6sLdy
         kB0zqoNUld1ztV2nalMarAL3QaVxy2gwYr2/A=
MIME-Version: 1.0
Date: Fri, 6 Feb 2009 09:43:23 +0100
Message-ID: <4dcf7d360902060043y7d11b9d7m94af9f7d06862660@mail.gmail.com>
Subject: Strange traffic control behaviour?
From: Lorenzo Allegrucci <l.allegrucci@gmail.com>
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I noticed a strange behaviour on a small sample network I used to test my
traffic control setup.
Below is the network setup (sorry for my ascii art..):

end user1|------------|router1|------------|router2|------------|end user2|
        eth0         eth1     eth0        eth0    eth1         eth0

(Static routes on router1 and router2).

Test1:

I applied the following tc rules on eth1 of router1 to limit the bandwidth
to 3Mbit for a download flux (by wget or scp) from "end user2" to "end user1":

tc qdisc add dev eth1 root handle 1:0 htb default 100
tc class add dev eth1 parent 1:0 classid 1:1 htb rate 3Mbit ceil 3Mbit
tc class add dev eth1 parent 1:1 classid 1:100 htb rate 2Mbit ceil 3Mbit
tc class add dev eth1 parent 1:1 classid 1:200 htb rate 1Mbit ceil 3Mbit

Theoretically "end user1" should get about 375kbyte/s (3Mbit), but instead
I get bit less, about 330 kbye/s and the flux tends to fluctuate a bit.
(all other interfaces are "clean", no tc rules).

Test2:

However, if I apply the same tc rules to the router2's eth0 instead, I get
a *stable* flux of *exactly* 3Mbit (375kbyte/s), to be more precise what
I should have gotten on test1!

How can this be explained?

In general, noticed that tc applied "upstream" gives better results than
tc applied downstream.  In other words, it's better to limit network
traffic near the source, can you confirm?

Thanks.

-- 
Lorenzo
