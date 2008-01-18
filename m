Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYARHYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYARHYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 02:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYARHYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 02:24:43 -0500
Received: from mail.cirrusrtps.com.au ([202.171.186.39]:32205 "EHLO
	mail.cirrusrtps.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYARHYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 02:24:41 -0500
X-Greylist: delayed 2570 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 02:24:41 EST
Date: Fri, 18 Jan 2008 17:31:16 +1100
From: "Mark Hansen" <Mark.Hansen@cirrusrtps.com.au>
To: linux-kernel@vger.kernel.org
Message-ID: <L669EA1BDC369453cA3ACCF0A75D0F5A3.1200638498.mail.cirrusrtps.com.au@MHS>
Subject: priority based thread wakeup
x-scalix-Hops: 1
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Firstly, may I apologise as I am not a member of the LKML, and ask that 
I be CC'd in any responses that may be forthcoming.

My question concerns the following patch which was incorporated into the 
2.6.22 kernel (quoted from that change log):

>Today, all threads waiting for a given futex are woken in FIFO 
>order (first waiter woken first) instead of priority order.
>
>This patch makes use of plist (pirotity ordered lists) instead 
>of simple list in futex_hash_bucket.
>
>All non-RT threads are stored with priority MAX_RT_PRIO, causing
>them to be woken last, in FIFO order (RT-threads are woken first, 
>in priority order).
>
>Signed-off-by: Sebastien Dugue <sebastien.du...@bull.net>
>Signed-off-by: Pierre Peiffer <pierre.peif...@bull.net>

After updating to this version of the kernel, I was able to observe the 
above fix, where multiple RT threads invoking pthread_cond_wait(), and 
the highest priority thread will acquire the mutex first, after the 
thread holding the mutex calls pthread_cond_signal(); 
pthread_mutex_unlock()

However, since kernel 2.6.23, it seems that the functionality relating 
to this "priority based wakeup" has disappeared. 

I understand there have been significant changes in this kernel 
concerning the "Completely Fair Scheduler" replacing the "mainline" 
scheduler; however my understanding is that the RT functionality would 
be preserved. This does not appear to be the case based on repeating the 
experiment described above.

I was wondering if this functionality is considered no longer 
desirable/necessary?

If not, is it anticipated that this functionality could/would be 
included in a later kernel?

Regards,
Mark Hansen


