Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXDATL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXDATL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXDATL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:11:56 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54149 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXDATLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:11:55 -0400
Message-ID: <46100407.30403@us.ibm.com>
Date: Sun, 01 Apr 2007 14:12:07 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-cifs-client@lists.samba.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cifs and kthread_run / kernel_thread
References: <20070331120030.BE6A916387F@lists.samba.org>
In-Reply-To: <20070331120030.BE6A916387F@lists.samba.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>Hi all,
>
>I would like to use cifs inside linux-vserver guests. Discussion this with the 
>vserver people, we found that cifs is using the new kthread_run and the old 
>kernel_thread interface for starting kernel-threads. The old-style interface 
>renders cifs unusable inside a vserver-guest :-(
>
>My questions:
>
>i) Are there newer versions of cifs, where only kthread_run is used in all 
>places?
>
>  
>
No - IIRC the original patch (for the switch of cifs from kernel_thread 
to kthread) had a
minor implementation problem in handling the cifs_demultiplex thread, so 
this one small
area was left with the old style.

>iii) Is it difficult to switch to the new interface?
>  
>
No, I don't think so, but I have not investigated it.  We would be happy
to review and test a patch for this though.

>gs cifs # grep kthread_run *.[ch]
>cifsfs.c:       oplockThread = kthread_run(cifs_oplock_thread, 
>NULL, "cifsoplockd");
>cifsfs.c:       dnotifyThread = kthread_run(cifs_dnotify_thread, 
>NULL, "cifsdnotifyd");
>
>gs cifs # grep kernel_thread *.[ch]
>cifs.mod.c:     { 0x7e9ebb05, "kernel_thread" },
>connect.c:                      rc = (int)kernel_thread((void *)(void 
>*)cifs_demultiplex_thread, srvTcp,
>
>
>Thx,
>
>Wilhelm
>
>*********************************************
>  
>

