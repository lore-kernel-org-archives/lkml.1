Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbXGWO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbXGWO1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbXGWO1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:27:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:26859 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbXGWO1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fm7cnZsFfGjT51zr1Z9ZNA96YLIS+IZwiV8LNamcAtaKYsBq+BpFWA2tu73ZpQ9Nu+ej8k6e4ZPS+3RTLqV0p6Zkm2utlfo5yaQ7MJctbKXgPiavLdcF5tN5RIU158vyB7iM5MA80Y7+4JpTMlavzAldpiltTLe2IHZzApLah1Y=
Message-ID: <a0a62dfc0707230727r3d9b5f18i69156073e6e6d4a5@mail.gmail.com>
Date: Mon, 23 Jul 2007 09:27:06 -0500
From: "Adam Litke" <aglitke@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] spinlock in function hugetlb_fault could be deleted
Cc: LKML <linux-kernel@vger.kernel.org>, agl@us.ibm.com
In-Reply-To: <1185178727.4688.63.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185178727.4688.63.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.  hugetlb_instantiation_mutex is an extremely heavy-weight lock
whose days are numbered (hopefully).  It exists primarily to arbitrate
a race condition where n (n > 1) threads of execution race to satisfy
the same page fault for a process.  Even though only one hugetlb page
is needed, if (n) are not available, the application can receive a
bogus VM_FAULT_OOM.

Anyway, the hugetlb_instantiation_mutex approach has few friends
around here, so rather than making the code rely more heavily upon it,
perhaps you could focus you efforts on helping us remove it.

On 7/23/07, Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> Function hugetlb_fault needn't hold spinlock mm->page_table_lock,
> because when hugetlb_fault is called:
> 1) mm->mmap_sem is held already;
> 2) hugetlb_instantiation_mutex is held by hugetlb_fault, which prevents
> other threads/processes from entering this critical area. It's impossible
> for other threads/processes to change the page table now.

--
Adam Litke ( agl at us.ibm.com )
IBM Linux Technology Center
