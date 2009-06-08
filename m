Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZFHOiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZFHOiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZFHOir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:38:47 -0400
Received: from honey.thehive.com ([206.83.74.4]:49601 "EHLO honey.thehive.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZFHOiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:38:46 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2009 10:38:46 EDT
Message-Id: <8FDBF172-AAA8-4737-A6C6-50B468CA0CBF@thehive.com>
From: Matthew Von Maszewski <matthew@thehive.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: huge mem mmap eats all CPU when multiple processes 
Date: Mon, 8 Jun 2009 10:27:49 -0400
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[note: not on kernel mailing list, please cc author]

Symptom:  9 processes mmap same 2 Gig memory section for a shared C  
heap (lots of random access).  All process begin extreme CPU load in  
top.

- Same code works well when only single process access huge mem.
- Code works well with standard vm based mmap file and 9 processes.

Environment:

- Intel x86_64:  Dual core Xeon with hyperthreading (4 logical  
processors)
- 6 Gig ram, 2.5G allocated to huge mem
- tried with kernels 2.6.29.4 and 2.6.30-rc8
- following mmap() call has base address as NULL on first process,  
then returned address passed to subsequent processes (not threads,  
processes)

            m_MemSize=((m_MemSize/(2048*1024))+1)*2048*1024;
             m_BaseAddr=mmap(m_File->GetFixedBase(), m_MemSize,
                             (PROT_READ | PROT_WRITE),
                             MAP_SHARED, m_File->GetFileId(), m_Offset);


I am not a kernel hacker so I have not attempted to debug.  Will be  
able to spend time on a sample program for sharing later today or  
tomorrow.  Sending this note now in case this is already known.

Don't suppose this is as simple as a Copy-On-Write flag being set wrong?

Please send notes as to things I need to capture to better describe  
this bug.  Happy to do the work.

Thanks,
Matthew
