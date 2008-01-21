Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYAUE2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYAUE2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 23:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbYAUE2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 23:28:21 -0500
Received: from mail.cirrusrtps.com.au ([202.171.186.39]:21763 "EHLO
	mail.cirrusrtps.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbYAUE2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 23:28:20 -0500
Date: Mon, 21 Jan 2008 15:17:35 +1100
From: "Mark Hansen" <Mark.Hansen@cirrusrtps.com.au>
To: linux-kernel@vger.kernel.org
Message-ID: <L4C947D7AC60C41b8845C6CC0420CE0CB.1200889684.mail.cirrusrtps.com.au@MHS>
In-Reply-To: <4790AAC7.2080703@gmail.com>
Subject: RE: priority based thread wakeup
x-scalix-Hops: 1
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>My question concerns the following patch which was incorporated into 
the >>2.6.22 kernel (quoted from that change log):
... "futex priority based wakeup"
>>After updating to this version of the kernel, I was able to observe 
the >>above fix, where multiple RT threads invoking pthread_cond_wait(), 
and the >>highest priority thread will acquire the mutex first, after 
the thread >>holding the mutex calls pthread_cond_signal(); 
pthread_mutex_unlock()

>>However, since kernel 2.6.23, it seems that the functionality relating 
to >>this "priority based wakeup" has disappeared. 

>>I understand there have been significant changes in this kernel 
concerning >>the "Completely Fair Scheduler" replacing the "mainline" 
scheduler; >>however my understanding is that the RT functionality would 
be preserved. >>This does not appear to be the case based on repeating 
the experiment >>described above.

>Hi,
>   I am not sure if this is whats happening to you (*), but there is a 
>known problem in the mainline tree related to the system allowing lower 
>priority threads to stay on the CPU under certain circumstances.
>
>You can see the problem happening with the following test:
>
>http://rt.wiki.kernel.org/index.php/Preemption_Test
>
>and I know the problem goes back to at least 2.6.16.
>
>Steven Rostedt and I submitted some patches to address the issue, and 
>they have been accepted into Ingo's sched-devel tree.  I would suggest 
>trying your code against Ingo's tree and see if the problem persists. 
>You can get it from:
>
>git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched->de
vel.git

Thanks for the suggestion, however I've just tried this kernel, but the 
pthread_cond_wait() behaviour still remains as per 2.6.23 described 
above (i.e. highest prio thread doesnt get woken first).

>>(*) I have no information on whether the futex-plist implemetation was 

>>pulled from the tree to cause your regression.  

I've just had a look at the code from the 2.6.24 kernel and it seems as 
though the futex priority list patch code is still included. 

>>It is possible that the changes between 22 and 23 are just tickling 
>>your environment enough to bring out this RT-preempt issue.

Or that the changes between 22 and 23 are bringing out another issue 
whereby the desired behaviour of futex-plist is somehow being 
circumvented.

If so, my questions still stand to anyone who might know what has caused 
the change in pthread_cond_wait() behaviour for RT threads between the 
22 and 23 kernels.

Cheers,
Mark


