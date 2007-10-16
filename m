Return-Path: <linux-kernel-owner+w=401wt.eu-S933395AbXJPQ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbXJPQ2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759688AbXJPQ2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:28:09 -0400
Received: from mx1.suse.de ([195.135.220.2]:46632 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759607AbXJPQ2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:28:08 -0400
Date: Tue, 16 Oct 2007 18:28:06 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       akpm@linux-foundation.org, ak@suse.de
Subject: Re: [patch 0/2] Protect crashkernel against BSS overlap
Message-ID: <20071016162806.GB16521@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	akpm@linux-foundation.org, ak@suse.de
References: <20071015115042.391348549@strauss.suse.de> <20071016054956.GA4659@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016054956.GA4659@in.ibm.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-10-16 07:49]:
> 
> Shouldn't bootmem allocator have the functionality to flag an error if
> we try to reserve a memory which is already reserved? I see that bootmem
> allocator is currently printing a warning under CONFIG_DEBUG_BOOTMEM.

That's probably better, yes. See the next version.

> Wouldn't it be better if we reserve the code, data and bss memory also
> using bootmem allocator and when somebody tries to reserve craskernel memory
> and if there is an overlap, boot memory allocator should scream?

It's already marked as reserved. At least on i386 in my test.

> In second patch, you are checking for crash kernel reserved memory being
> beyond _end. That will make sure that there is no overlap with kernel
> text, data or bss. I am wondering then why do we need first patch and
> why should we register bss memory in the resources list. Second patch 
> would make sure that there is no overlap with crash kernel memory and kexec
> will not place any segment outside crashkernel memory.

I think we should also present the BSS to the user like we present
text and data.


Thanks,
   Bernhard
