Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbYFERN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbYFERN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYFERNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:13:51 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:41098 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYFERNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=WA1Vo4zK606FTmfyVxErWKncKQh8GyLgZ9D1UzWIXQmjRLvudspaSS5gF4qIphcd7e
         x6VV+irJYT0nzgjOac+RN8LuXo44BD9wvuTI1clJomdeFcw/OvDqFTNYpkMpl2JiYGzv
         m2iss0tZd9NdEi77rotWLjUh9ikS7e/GeWIVA=
Message-ID: <89cb5ede0806051013o15e2d51tb9acf9e237b15d38@mail.gmail.com>
Date: Thu, 5 Jun 2008 20:13:48 +0300
From: "Khaled Al-Hamwi" <khaled.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: SMP Affinity Issue with IRQ#
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I am trying to evaluate the performance of a Linux box when working as
IP forwarder.
I have a hardware traffic generator IXIA T400 on one end.
On the other end, I have a Linux box with kernel 2.6.16 and quad-core xeon CPU.

These two systems are connected through two crossover Gigabit cables and NICs.
The traffic is sent from IXIA through one NIC to the forwarding machine
and then it is forwarded back through the other NIC to IXIA.

I have two issues related to SMP affinity.
The first one is that when I set the SMP affinity through
/proc/irq/<IRQ#>/smp_affinity, it changes dynamically.
Is there any load balancing in the system that changes the affinity
after some time or after some packets are received?
Is there a way to set it permanently?

The second issue is that changing the SMP affinity results in
different delay and throughput measurements.
I am assigning each NIC to a different CPU.
If I used a different assignment but still each NIC is assigned to a
different CPU, I am getting different performance results.
I would expect that changing the assignment should yield the same
performance results.
The CPUs are identical and should have similar performance.
Here, I have two examples of two different assignments:
Example 1:
/proc/irq/16/smp_affinity (eth0)  ->   CPU#1
/proc/irq/20/smp_affinity (eth1)  ->   CPU#2
Example 2:
/proc/irq/16/smp_affinity (eth0)  ->   CPU#3
/proc/irq/20/smp_affinity (eth1)  ->   CPU#2
Which one of these two configurations can be used as a reference for
performance evaluation?

Any ideas??

Your help is appreciated.

Thank you,
Khaled
