Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbYHAMGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbYHAMGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbYHAMGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:06:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbYHAMGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:06:38 -0400
Message-ID: <4892FC11.4020105@redhat.com>
Date: Fri, 01 Aug 2008 08:05:37 -0400
From: Ric Wheeler <rwheeler@redhat.com>
Reply-To: rwheeler@redhat.com
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Josef Bacik <jbacik@redhat.com>, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: high resolution timers, scheduling & sleep granularity
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas & Ingo,

Josef has been working on some patches to try and get ext3/4 to 
dynamically detect the latency of a storage device and use that base 
latency to tune the amount of time we sleep waiting for others to join 
in a transaction. The logic in question lives in jbd/transaction.c 
(transaction_stop).

The code was originally developed to try and allow multiple threads to 
join in a big, slow transaction. For example, transacations that write 
to a slow ATA or S-ATA drive take in the neighborhood of 10 to 20 ms.

Faster devices, for example a disk array,  can complete the transaction 
in 1.3 ms. Even higher speed SSD devices boast of a latency of 0.1ms, 
not to mention RAM disks ;-)

The current logic makes us wait way too long, especially with a 250HZ 
kernel since we sleep many times longer than it takes to complete the IO ;-)

Do either of you have any thoughts on how to get a better, fine grained 
sleep capability that we could use that would allow us to sleep in 
sub-jiffie chunks?

Regards,

Ric

