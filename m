Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZI2Pdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZI2Pdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 11:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZI2Pdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 11:33:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbZI2Pde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 11:33:34 -0400
Date: Tue, 29 Sep 2009 08:33:22 -0700
From: Greg KH <greg@kroah.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au, akpm@linux-foundation.org, rientjes@google.com
Subject: Re: [PATCH] linux-next: 20090929 - android driver build breaks
Message-ID: <20090929153322.GD5020@kroah.com>
References: <20090929140404.dfb2c5f5.sfr@canb.auug.org.au> <20090929152027.GC4373@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929152027.GC4373@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 08:50:27PM +0530, Kamalesh Babulal wrote:
> Hi Greg,
> 
> 	next-20090929 randconfig build breaks with
> CONFIG_ANDROID_LOW_MEMORY_KILLER=y
> 
> drivers/staging/android/lowmemorykiller.c: In function 'lowmem_shrink':
> drivers/staging/android/lowmemorykiller.c:111: error: 'struct mm_struct' has no member named 'oom_adj'
> make[3]: *** [drivers/staging/android/lowmemorykiller.o] Error 1
> 
> Commit 0753ba01e126020bf0f8150934903b48935b697d was reverted back,
> which moves back oom_adj from mm_struct to task_struct and commit 
> 28b83c5193e7ab951e402252278f2cc79dc4d298 moved the oomkilladj
> from task_struct to signal_struct. 
> 
> Following patch reverts the changes introduced by commit 
> a6a9f81ccc9f5c86ccc22bbed1960a57d0316e8b to
> drivers/staging/android/lowmemorykiller.c 

Ick, what a mess.  I'll queue this up, thanks.

greg k-h
