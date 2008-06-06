Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbYFFVvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbYFFVvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933501AbYFFVvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:51:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53314 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933487AbYFFVvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:51:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=WydEqrqf2yBa7BzBFANkHjopub3kbk6D/ZISDYoClf9PMUOhrKPAjdbX8u5heLAPd
	j0S+hGOHjQ+id+8qV7Z/A==
Message-ID: <da824cf30806061451p4005a4ecoa9af8687e3ec51e5@mail.gmail.com>
Date: Fri, 6 Jun 2008 14:51:17 -0700
From: "Grant Grundler" <grundler@google.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, mgross@linux.intel.com,
       linux-scsi@vger.kernel.org
In-Reply-To: <20080606213659.GC15085@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
	 <da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com>
	 <20080606202119.GQ15085@il.ibm.com>
	 <da824cf30806061428t4b7ed816i74d961946d77c88b@mail.gmail.com>
	 <20080606213659.GC15085@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 2:36 PM, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
...
> The logic seems pretty simple to me, all we need to do is keep track
> of how many entries are currently allocated in the bitmap vs. the size
> of the bitmap. Once we get to the half-way point, double the size of
> the bitmap.

"half-full" would be one hueristic but others might be more suitable
(e.g. wait until it's
nearly full or bitmap search fails).

> Having said that, I'm not sure it's worth it, and have no
> plans to implement it :-)

The historical DMA mapping "failure mode" is a kernel panic.  Resizing or
creating  a new IOMMU page table would avoid a panic, my guess is people
would prefer _anything_ that avoids a panic. :) Especially in the context of
Virtual Machines and multiply guests.

And I'm not exposed to this problem (yet)...I expect Mark Gross
(Intel) is on the
hook for this and has access to all the documentation.

I'll let him thank you for suggesting more work. :P

thanks,
grant
