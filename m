Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbXHWHl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbXHWHl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 03:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759128AbXHWHln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 03:41:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:48539 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545AbXHWHlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 03:41:42 -0400
Subject: Re: [BUG] 2.6.23-rc3-mm1 Oops: Machine check, sig: 7 [#1]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070822090858.b8f62539.akpm@linux-foundation.org>
References: <46CC387D.4000605@linux.vnet.ibm.com>
	 <20070822090858.b8f62539.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 09:42:10 +0200
Message-Id: <1187854930.5972.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> It would be great if you could fix that wordwrapping problem.
> 
> Dunno, it beats me.  powerpc booted OK for me.  Ben, have you been playing
> around in powerpc mmap code?  How come the oops claims it died at
> kernel_execve+0x8/0x14 but the call trace points up into the vma management
> code?

I haven't changed anything that would cause such a symptom in the VMA
code... The machine check looks to me like we are accessing a stale
pointer that happens to correspond to some part of IO space that is
mapped but not responding (like PCI PIO space).

I'm travelling (and quite sick too) right now, so I can't really do much
about it at this stage. But it happens early enough that putting a
printk in vma_link_rb() to printk the various pointers involved before
dereferencing them might help.

Cheers,
Ben.


