Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbZFKHbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbZFKHbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZFKHbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:31:31 -0400
Received: from web15705.mail.cnb.yahoo.com ([202.165.102.72]:35835 "HELO
	web15705.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750860AbZFKHba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:31:30 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 03:31:30 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=0zBE2YPQNunfIg6t34xjbEHC5xG9VKP4xz/fVEWLPsDGh3cKr8D8/pNvFeHrR2x+kzDin6QSM7etCBb3b6SixMq8T2s95pde19NeWpguydQefPySht1hsDLuCOohTV1mPzyWcy7OHP4Qxb+hvvoykEoYEV0YB3TOu/yCJArSLMo=;
Message-ID: <653414.78162.qm@web15705.mail.cnb.yahoo.com>
X-YMail-OSG: Pnv6QTcVM1lh5QfoLBZHB0LKQcqw48QJopPZdrtdNAqJ8tvMxNHV0hAgH_PEtgejolwXjo7UH.bJbi7029Sj9PULqZ3FBbaTLvErcii0CpVouTMTejo1.igcl22ix6fadycp5gHiHk2AiZRGjmfWTXWU3HIFtk89igngJBvfDYsO6M4-
X-Mailer: YahooMailClassic/5.4.12 YahooMailWebService/0.7.289.15
Date: Thu, 11 Jun 2009 15:24:51 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Subject: Ask a question of ksoftirqd related call trace 
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

I met a problem as follow .
As i understand , ksoftirqd is kernel thread therefore the virtual is above 0xc0000000. but the threadinfo=81168000, task=811636a8 and call trace is 80134058 .... .  seems fault is at <8c820000> 
These address is user space address not kernel space address .
How to analyse this issue ? 
 
---------------------------------------------------------------------
CPU 0 Unable to handle kernel paging request at virtual address 30305230, epc == 80134384, ra == 80134bec
Oops in arch/mips/mm/fault.c::do_page_fault, line 167[#1]:
Cpu 0
$ 0   : 00000000 10008500 83f8dcc0 83f8dcc0
$ 4   : 30305230 00000000 000000a8 00000001
$ 8   : 81169fe0 00008500 00000000 80226000
$12   : 0000ffff 00008000 00007fff 00000380
$16   : 83b49ca0 00000000 c0097428 c03274b0
$20   : 80134124 00000000 c00974f4 c009737c
$24   : 00000000 2af470c0                  
$28   : 81168000 81169de8 c008a594 80134bec
Hi    : 00000280
Lo    : 00000230
epc   : 80134384     Tainted: P  
ra    : 80134bec Status: 10008502    KERNEL EXL 
Cause : 00000008
BadVA : 82cec220
PrId  : 0002a010
Process ksoftirqd/0 (pid: 2, threadinfo=81168000, task=811636a8)
Stack : 00000020 80134058 83b49ee0 82f2d280 83b49ca0 83b49ca0 80134bec 00000000
        00007c58 0000001a 00000067 0cb7bec0 00000000 80134298 00000002 
        ...
Call Trace: [<80134058>]  [<80134bec>]  [<80134298>]  [<c0097428>]  [<c009a1a4>]  [<c0092fcc>]  [<80032b90>]  [<c0099efc>]  [<c009a678>]  [<c01a8b40>]  [<80250000>]  [<8003a97c>]  [<8003a97c>]  [<8003a3d0>]  

Code: 001110c0  00431021  8c440010 <8c820000> 000212c2  30420001  14400011  00000000  8c830004 
note: ksoftirqd/0[2] exited with preempt_count 256
--------------------------------------------------------------------------

Thanks advanced 
Best Regards
Peter Meng 


      
