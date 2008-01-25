Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbYAYBps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbYAYBps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYAYBpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:45:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:55327 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751770AbYAYBpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:45:39 -0500
X-Authenticated: #759291
X-Provags-ID: V01U2FsdGVkX1+Om7ss1JyOM067DK86+zNlRFpcyV071CSBzO7gHR
	ocAWZTe60AVeme
From: Matthias Wolle <Matthias.Wolle@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: LowFree/LowMem problem
Date: Fri, 25 Jan 2008 02:45:34 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200801210632.42497.Matthias.Wolle@gmx.de> <200801232340.54258.Matthias.Wolle@gmx.de> <p73d4rrae1y.fsf@bingen.suse.de>
In-Reply-To: <p73d4rrae1y.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801250245.35013.Matthias.Wolle@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008 08:16 Andi Kleen wrote:
> Do you perhaps have a kernel compiled without CONFIG_HIGHPTE? Normally
> __pte_alloc should be able to allocate highmem unless that option is
> not set. Before HIGHPTE was implemented running out of low memory
> due to page tables was pretty common.

The kernel from 17th Jan 2008 didn't have CONFIG_HIGHPTE enabled. Yesterday we 
checked a 2.6.23.14 kernel with CONFIG_HIGHPTE enabled. The 4GB test machine 
showed the same fast low memory reducing effect. LowFree stopped at 400MB 
like without CONFIG_HIGHPTE.  A 2GB machine had a limit of 690MB LowFree. The 
difference of LowTotal and LowFree is shown as used memory. In case of the 
4GB machine, this means I have 400MB used memory which is not related to any 
process. 
I hope this helps. I can't test on the 16GB RAM machines anymore, because they 
are working productive now.  

> BTW the ultimate fix for most lowmem problems is to go 64bit

We switched back to the distribution default 2.6.18-bigmem kernel of debian 
which doesn't have this problem. On this kernel the test script has no effect 
to the low memory. 

Regards
Matthias

On Thursday 24 January 2008 08:16 Andi Kleen wrote:
> Matthias Wolle <Matthias.Wolle@gmx.de> writes:
> > Jan 17 23:31:58 franklin72 kernel: sshd invoked oom-killer:
> > gfp_mask=0xd0, order=0, oomkilladj=0 Jan 17 23:31:58 franklin72 kernel:
> > cat invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0 Jan 17
> > 23:31:58 franklin72 kernel:  [<c014af39>] out_of_memory+0x69/0x1a4 Jan 17
> > 23:31:58 franklin72 kernel:  [<c014c588>] __alloc_pages+0x20a/0x291 Jan
> > 17 23:31:58 franklin72 kernel:  [<c0153618>] __pte_alloc+0x11/0x94
>
> Do you perhaps have a kernel compiled without CONFIG_HIGHPTE? Normally
> __pte_alloc should be able to allocate highmem unless that option is
> not set. Before HIGHPTE was implemented running out of low memory
> due to page tables was pretty common.
>
> BTW the ultimate fix for most lowmem problems is to go 64bit
>
> -Andi
