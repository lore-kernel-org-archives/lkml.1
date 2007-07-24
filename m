Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbXGXAEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbXGXAEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 20:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbXGXAEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 20:04:10 -0400
Received: from mga05.intel.com ([192.55.52.89]:57110 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752432AbXGXAEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 20:04:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="271795821"
Subject: Re: [PATCH] spinlock in function hugetlb_fault could be deleted
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Adam Litke <aglitke@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, agl@us.ibm.com
In-Reply-To: <a0a62dfc0707230727r3d9b5f18i69156073e6e6d4a5@mail.gmail.com>
References: <1185178727.4688.63.camel@ymzhang>
	 <a0a62dfc0707230727r3d9b5f18i69156073e6e6d4a5@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 24 Jul 2007 08:03:08 +0800
Message-Id: <1185235388.4688.68.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 09:27 -0500, Adam Litke wrote:
> Hello.  hugetlb_instantiation_mutex is an extremely heavy-weight lock
> whose days are numbered (hopefully).  It exists primarily to arbitrate
> a race condition where n (n > 1) threads of execution race to satisfy
> the same page fault for a process.  Even though only one hugetlb page
> is needed, if (n) are not available, the application can receive a
> bogus VM_FAULT_OOM.
Thanks for your kind comments.

> 
> Anyway, the hugetlb_instantiation_mutex approach has few friends
> around here, so rather than making the code rely more heavily upon it,
> perhaps you could focus you efforts on helping us remove it.
That's the correct direction. I will check if the mutex could be removed. 

> 
> On 7/23/07, Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > Function hugetlb_fault needn't hold spinlock mm->page_table_lock,
> > because when hugetlb_fault is called:
> > 1) mm->mmap_sem is held already;
> > 2) hugetlb_instantiation_mutex is held by hugetlb_fault, which prevents
> > other threads/processes from entering this critical area. It's impossible
> > for other threads/processes to change the page table now.
> 
