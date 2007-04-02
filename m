Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbXDBIB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbXDBIB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 04:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXDBIB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 04:01:27 -0400
Received: from mx28.mail.ru ([194.67.23.67]:26304 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbXDBIB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 04:01:26 -0400
Message-ID: <4610B80F.9020102@mail.ru>
Date: Mon, 02 Apr 2007 12:00:15 +0400
From: "Q (Igor Mammedov)" <qwerty0987654321@mail.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: "Steve French (smfltc)" <smfltc@us.ibm.com>
CC: linux-cifs-client@lists.samba.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: cifs and kthread_run / kernel_thread
References: <20070331120030.BE6A916387F@lists.samba.org> <46100407.30403@us.ibm.com>
In-Reply-To: <46100407.30403@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French (smfltc) wrote:
> 
>> Hi all,
>>
>> I would like to use cifs inside linux-vserver guests. Discussion this 
>> with the vserver people, we found that cifs is using the new 
>> kthread_run and the old kernel_thread interface for starting 
>> kernel-threads. The old-style interface renders cifs unusable inside a 
>> vserver-guest :-(
>>
>> My questions:
>>
>> i) Are there newer versions of cifs, where only kthread_run is used in 
>> all places?
>>
>>  
>>
> No - IIRC the original patch (for the switch of cifs from kernel_thread 
> to kthread) had a
> minor implementation problem in handling the cifs_demultiplex thread, so 
> this one small
> area was left with the old style.
> 
>> iii) Is it difficult to switch to the new interface?
>>  
>>
> No, I don't think so, but I have not investigated it.  We would be happy
> to review and test a patch for this though.
> 
>> gs cifs # grep kthread_run *.[ch]
>> cifsfs.c:       oplockThread = kthread_run(cifs_oplock_thread, NULL, 
>> "cifsoplockd");
>> cifsfs.c:       dnotifyThread = kthread_run(cifs_dnotify_thread, NULL, 
>> "cifsdnotifyd");
>>
>> gs cifs # grep kernel_thread *.[ch]
>> cifs.mod.c:     { 0x7e9ebb05, "kernel_thread" },
>> connect.c:                      rc = (int)kernel_thread((void *)(void 
>> *)cifs_demultiplex_thread, srvTcp,
>>
>>
>> Thx,
>>
>> Wilhelm
>>
>> *****************************************

It seems to me that I rewrote cifs_demultiplex_thread to use kthread_run 
in DFS patch.

-- 

Best regards,

-------------------------
Igor Mammedov,
niallain "at" gmail.com




