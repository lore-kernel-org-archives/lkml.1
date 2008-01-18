Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbYARNeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbYARNeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759143AbYARNeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:34:09 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:8437 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594AbYARNeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:34:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=gyo6iUiXpU9ee4qccUWDlHJVLjZWihGU5WIdmYxjf+W9wVET2yWfs4/gvbJEuMB3M+Fd9Yco6ZIP7CH+1DG/mD8CDvwxtdR+cmsoSJ5eCkhuu55s7GgAhctZlw32i0+IB9l36VepoiSTCOv/maZcSwPDBlVtHRQ+I5ZpH7Qr7jc=
Message-ID: <4790AAC7.2080703@gmail.com>
Date: Fri, 18 Jan 2008 08:33:59 -0500
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Mark Hansen <Mark.Hansen@cirrusrtps.com.au>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       rostedt@goodmis.org
Subject: Re: priority based thread wakeup
References: <L669EA1BDC369453cA3ACCF0A75D0F5A3.1200638498.mail.cirrusrtps.com.au@MHS>
In-Reply-To: <L669EA1BDC369453cA3ACCF0A75D0F5A3.1200638498.mail.cirrusrtps.com.au@MHS>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hansen wrote:
> Hello,
> 
> Firstly, may I apologise as I am not a member of the LKML, and ask that 
> I be CC'd in any responses that may be forthcoming.
> 
> My question concerns the following patch which was incorporated into the 
> 2.6.22 kernel (quoted from that change log):
> 
>> Today, all threads waiting for a given futex are woken in FIFO 
>> order (first waiter woken first) instead of priority order.
>>
>> This patch makes use of plist (pirotity ordered lists) instead 
>> of simple list in futex_hash_bucket.
>>
>> All non-RT threads are stored with priority MAX_RT_PRIO, causing
>> them to be woken last, in FIFO order (RT-threads are woken first, 
>> in priority order).
>>
>> Signed-off-by: Sebastien Dugue <sebastien.du...@bull.net>
>> Signed-off-by: Pierre Peiffer <pierre.peif...@bull.net>
> 
> After updating to this version of the kernel, I was able to observe the 
> above fix, where multiple RT threads invoking pthread_cond_wait(), and 
> the highest priority thread will acquire the mutex first, after the 
> thread holding the mutex calls pthread_cond_signal(); 
> pthread_mutex_unlock()
> 
> However, since kernel 2.6.23, it seems that the functionality relating 
> to this "priority based wakeup" has disappeared. 
> 
> I understand there have been significant changes in this kernel 
> concerning the "Completely Fair Scheduler" replacing the "mainline" 
> scheduler; however my understanding is that the RT functionality would 
> be preserved. This does not appear to be the case based on repeating the 
> experiment described above.
> 
> I was wondering if this functionality is considered no longer 
> desirable/necessary?
> 
> If not, is it anticipated that this functionality could/would be 
> included in a later kernel?
>

Hi Mark,
   In a coffee deprived stupor ;), I responded to this mail in the wrong 
thread, here:

http://lkml.org/lkml/2008/1/18/207

Sorry for the confusion
HTH

-Greg


> Regards,
> Mark Hansen
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

