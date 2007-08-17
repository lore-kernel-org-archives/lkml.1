Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbXHQEi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbXHQEi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXHQEiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:38:08 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:63687 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbXHQEh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:37:56 -0400
Message-ID: <46C52615.80205@linux.vnet.ibm.com>
Date: Fri, 17 Aug 2007 10:07:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Machine automagically reboots with 2.6.23-rc2-mm2
References: <46C4C26C.3090502@linux.vnet.ibm.com> <30255.1187317044@neuling.org>
In-Reply-To: <30255.1187317044@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling wrote:
> 
> SLB shadow was bust.  Make sure you have
> edd0622bd2e8f755c960827e15aa6908c3c5aa94
> 
>     [POWERPC] Fix potential duplicate entry in SLB shadow buffer
>     
>     We were getting a duplicate entry in the SLB shadow buffer in
>     slb_flush_and_rebolt() if the kernel stack was in the same segment
>     as PAGE_OFFSET, which on POWER6 causes the hypervisor to terminate
>     the partition with an error.  This fixes it.
>     
>     Also we were not creating an SLB entry (or an SLB shadow buffer
>     entry) for the kernel stack on secondary CPUs when starting the
>     CPU.  This isn't a major problem, since an appropriate entry will
>     be created on demand, but this fixes that also for consistency.
>     
>     Signed-off-by: Paul Mackerras <paulus@samba.org>
> 

Thanks for pointing that out, I'll get the fix and retry.

Balbir Singh.
