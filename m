Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbXH2RMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbXH2RMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXH2RMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:12:05 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56552 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbXH2RME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:12:04 -0400
Message-ID: <46D5A8F9.2010109@us.ibm.com>
Date: Wed, 29 Aug 2007 12:12:25 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: Michael Deegan <michael@ucc.gu.uwa.edu.au>,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] Re: BUG: scheduling while atomic - linux
 2.6.22
References: <20070827231104.GN4867@wibble.darktech.org> <1188402233.6529.25.camel@norville.austin.ibm.com>
In-Reply-To: <1188402233.6529.25.camel@norville.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp wrote:

>On Tue, 2007-08-28 at 07:11 +0800, Michael Deegan wrote:
>  
>
>>Hi,
>>
>>On Tue Aug 7 16:00:19 GMT 2007, Martin Koegler  wrote:
>>    
>>
>>>A vanilla 2.6.22 kernel (SMP PREEMPT i686) produced the following messages, while working with a CIFS mount point:
>>>      
>>>
>>Aug 27 22:33:08 wibble kernel: BUG: scheduling while atomic: bash/0x00000001/4077
>>Aug 27 22:33:08 wibble kernel:
>>Aug 27 22:33:08 wibble kernel: Call Trace:
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff805265df>] __sched_text_start+0x5f/0x79b
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff8049cb7a>] kernel_sendmsg+0x2c/0x3e
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff8032ba42>] wait_for_response+0xbe/0x155
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff802392bf>] autoremove_wake_function+0x0/0x2e
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff8032c0e1>] SendReceive+0x1fb/0x3f8
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff803192c2>] CIFSSMBOpen+0x1c6/0x27a
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff80323b8a>] cifs_reopen_file+0x1ea/0x356
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff8032455c>] find_writable_file+0x84/0xe7
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff80324b51>] is_size_safe_to_change+0x16/0x4e
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff8032fbc7>] fill_in_inode+0x270/0x4ec
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff80330c67>] cifs_readdir+0xe24/0x1071
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff802733c8>] filldir64+0x0/0xb8
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff80218c71>] do_page_fault+0x40b/0x74a
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff80527ffb>] __mutex_lock_slowpath+0x234/0x23f
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff802733c8>] filldir64+0x0/0xb8
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff80273594>] vfs_readdir+0x5d/0x92
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff8027363e>] sys_getdents64+0x75/0xba
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff8052948d>] error_exit+0x0/0x84
>>Aug 27 22:33:08 wibble kernel:  [<ffffffff8020958e>] system_call+0x7e/0x83
>>Aug 27 22:33:08 wibble kernel:
>>
>>I'm using a 2.6.22.1 kernel (with SMP and PREEMPT, including BKL) on Debian
>>etch AMD64, and Samba 3.0.24-6etch4.
>>    
>>
>
>This is a known problem that is fixed in 2.6.23-rc4.  cifs_readdir()
>takes a spinlock and calls a blocking function.  The fix is here:
>http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a403a0a370946e7dbcda6464a3509089daee54bc
>
>Steve,
>Has this patch been submitted to the stable kernel?
>
>  
>
No - but seems like a resonable idea, although a little larger than 
typical patch to stable kernel.
