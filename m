Return-Path: <linux-kernel-owner+w=401wt.eu-S933997AbYCFMm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbYCFMm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765536AbYCFMmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:42:14 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:52380 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756999AbYCFMmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:42:12 -0500
From: Srinivasa DS <srinivasa@in.ibm.com>
Organization: IBM
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [BUG] Kprobes fails on 2.6.25-rc3-mm1 (x86) systems, if CONFIG_DEBUG_RODATA is set.
Date: Thu, 6 Mar 2008 18:11:27 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com, SystemTAP <systemtap@sources.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803061811.27555.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Insertion of kprobe module causes oops on 2.6.25-rc3-mm1 (x86) systems if we 
enable CONFIG_DEBUG_RODATA.  While registering the probe, memcpy() fails to 
copy breakpoint instruction to the instruction address and generates the 
oops.

BUG: unable to handle kernel paging request at ffffffff8047d1a7
IP: [<ffffffff8047ff62>] text_poke+0xa/0x10
PGD 203067 PUD 207063 PMD 7e191163 PTE 47d161
Oops: 0003 [1] PREEMPT SMP
................................................

This is because, Mathieu's patch (http://lkml.org/lkml/2008/2/2/226) makes 
entire text segment as READONLY, if we enable CONFIG_DEBUG_RODATA. 

So reverting this patch or new patch, which considers kprobes while deciding  
boundary for setting readonly pages might solve the probelm.

Thanks
 Srinivasa DS
 LTC-IBM
 



