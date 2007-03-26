Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbXCZGgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbXCZGgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 02:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932081AbXCZGgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 02:36:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:11871 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbXCZGgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 02:36:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=PSR0hHcQZwje/js2Ew4dDyeUehq46ECdEVG7LXrUFVS0Dfs7wimCI/J0t4Y6qv9Yf
	7WwI9iKFZ/6Y2PtkUye8Q==
Date: Sun, 25 Mar 2007 23:35:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zachary Amsden <zach@vmware.com>
cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 1/2] i386: add ptep_test_and_clear_{dirty,young}
In-Reply-To: <4607713F.6010900@vmware.com>
Message-ID: <Pine.LNX.4.64.0703252334110.4535@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0703251731040.19025@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703260631150.15998@blonde.wat.veritas.com> <4607713F.6010900@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007, Zachary Amsden wrote:

> If you actually clear the bit, you need to:
> 
> +         pte_update_defer(vma->vm_mm, addr, ptep);
> 
> The reason is, when updating PTEs, the hypervisor must be notified.  Using
> atomic operations to do this is fine for all hypervisors I am aware of.
> However, for hypervisors which shadow page tables, if these PTE modifications
> are not trapped, you need a post-modification call to fulfill the update of
> the shadow page table.
> 

Then why was ptep_test_and_clear_{dirty,young} ever removed in the first 
place??  To gain the optimization of one fewer branch and introduce a hack 
to advertise it's existance so the generic header file doesn't include its 
own version?
