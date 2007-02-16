Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbXBPVkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbXBPVkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932426AbXBPVkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:40:33 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:41313 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbXBPVkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:40:32 -0500
Message-ID: <45D62472.9030202@mvista.com>
Date: Fri, 16 Feb 2007 11:38:58 -1000
From: akuster <akuster@mvista.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [Question]  detach_vmas_to_be_unmapped
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am a bit confused on why the vm start and end address where swapped in 
arch_unmap_area and arch_unmap_area_topdown functions after the official 
Avoiding mmap fragmentation ( 1363c3cd8603a913a27e2995dccbd70d5312d8e6 ) 
patch.

Prior to this patch arch_unmap_area() used area->vm_start and 
arch_unmap_area_topdown used area->vm_end after the patch the following 
change showed up.

if (mm->unmap_area == arch_unmap_area)
     addr = prev ? prev->vm_start : mm->mmap_base;
else
     addr = vma ?  vma->vm_end : mm->mmap_base;

Using Wolfgang Wander's leakme.c test, I get the same results seen with 
his original "Avoiding mmap fragmentation" patch as I do after swapping 
  the start & end address in the above code segment.

Is it just a typo in the official patch or am I missing the much bigger 
picture?

Note: I have only run this on an Pentium4 with 1GiG memory.

TIA

Armin

