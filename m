Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXCZTYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXCZTYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbXCZTYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:24:24 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37549 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932244AbXCZTYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:24:23 -0400
Message-ID: <46082BE6.30402@vmware.com>
Date: Mon, 26 Mar 2007 12:24:06 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> 	Date: Sun, 25 Mar 2007 23:07:43 -0800
> 	From: Zachary Amsden <zach@vmware.com>
>
> 	If you actually clear the bit, you need to:
>
> 	+         pte_update_defer(vma->vm_mm, addr, ptep);
>
> 	The reason is, when updating PTEs, the hypervisor must be notified.  Using
> 	atomic operations to do this is fine for all hypervisors I am aware of.
> 	However, for hypervisors which shadow page tables, if these PTE
> 	modifications are not trapped, you need a post-modification call to fulfill
> 	the update of the shadow page table.
>
> Cc: Zachary Amsden <zach@vmware.com>
> Cc: Hugh Dickins <hugh@veritas.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
>   

Acked-by: Zachary Amsden <zach@vmware.com>

David, thanks for cleaning this up.
