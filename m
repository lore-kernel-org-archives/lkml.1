Return-Path: <linux-kernel-owner+w=401wt.eu-S1762519AbXEWP05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762519AbXEWP05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761717AbXEWP0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:26:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:44842 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760870AbXEWP0f (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:26:35 -0400
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
From: "Richard Griffiths (wrs)" <richard.griffiths@windriver.com>
Reply-To: richard.griffiths@windriver.com
To: carsteno@de.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-kernel@vger.kernel.org
In-Reply-To: <4653F264.1030807@de.ibm.com>
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <4653F264.1030807@de.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Product Development
Date: Wed, 23 May 2007 08:25:16 -0700
Message-Id: <1179933916.8223.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 23 May 2007 15:25:17.0049 (UTC) FILETIME=[9115E690:01C79D4E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 09:51 +0200, Carsten Otte wrote:
> Andrew Morton wrote:
> > But we'd expected and hoped that flash-based XIP would be able to use
> > the existing xip infrastructure, in mm/filemap_xip.c.  Not possible?
> Thanks for the heads up Andrew. Reading the cramfs patch, I've found a 
> lot of similarities between the current mainline xip stack and this 
> nice piece of work. I also observed interresting differences:
> 
> The current xip stack does use the block device abstraction added with 
> an extra direct memory access operation. The cramfs patch does not 
> abstract between the memory segment and the file system, it rather 
> uses an address as mount parameter.
> Both methods can coexist, and a file system that does not use the 
> block device abstraction may still provide get_xip_page address space 
> operation and benefit from the xip stack infrastructure. Each method 
> makes sense in the context of the corresponding file systems.
> 
> The current xip stack relies on having struct page behind the memory 
> segment. This causes few impact on memory management, but occupies 
> some more memory. The cramfs patch chose to modify copy on write in 
> order to deal with vmas that don't have struct page behind.
> So far, Hugh and Linus have shown strong opposition against copy on 
> write with no struct page behind. If this implementation is acceptable 
> to the them, it seems preferable to me over wasting memory. The xip 
> stack should be modified to use this vma flag in that case.
> 
> This implementation extends cramfs while the current xip stack extends 
> ext2. I would love to see a cramfs implementation based on 
> filemap_xip, choice is always a good thing. To me, it looks like this 
> work can be modified to use filemap_xip.
One question I have is the difference in the two models. If I understand
correctly the filemap_xip expects the ext2 to mount as XIP while the
Linear Cramfs only enables XIP for apps that have the sticky bit set.
Hence the Application XIP moniker.
Does the filemap_xip expect the entire filesystem is XIP?

Thanks,
Richard
