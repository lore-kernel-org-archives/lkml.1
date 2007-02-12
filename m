Return-Path: <linux-kernel-owner+w=401wt.eu-S1030212AbXBLWPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212AbXBLWPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030213AbXBLWPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:15:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:12024 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030212AbXBLWO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:14:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Hjgueafp5f0/myolGYP0sWjotPhp8xrxsrBWURXaWge1S/w7gQhCZSoZBwx6JdMXe
	CjGuL3CYy4ijLo+PtYkoA==
Message-ID: <b040c32a0702121414oc570ccfhd8b78a87c5ff7b86@mail.gmail.com>
Date: Mon, 12 Feb 2007 14:14:43 -0800
From: "Ken Chen" <kenchen@google.com>
To: "Dave McCracken" <dave.mccracken@oracle.com>
Subject: Re: [PATCH 1/1] Enable fully functional truncate for hugetlbfs
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Adam Litke" <agl@us.ibm.com>
In-Reply-To: <20070212142802.15738.80487.sendpatchset@wildcat.int.mccr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212142802.15738.80487.sendpatchset@wildcat.int.mccr.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Dave McCracken <dave.mccracken@oracle.com> wrote:
> This patch enables the full functionality of truncate for hugetlbfs
> files.  Truncate was originally limited to reducing the file size
> because page faults were not supported for hugetlbfs.  Now that page
> faults have been implemented it is now possible to fully support
> truncate.

ye!

> --- 2.6.20/./fs/hugetlbfs/inode.c       2007-02-04 12:44:54.000000000 -0600
> +++ 2.6.20-htrunc/./fs/hugetlbfs/inode.c        2007-02-05 13:02:00.000000000 -0600
> +       if (hugetlb_reserve_pages(inode, inode->i_size >> HPAGE_SHIFT,
> +                                 offset >> HPAGE_SHIFT))
> +               goto out_mem;
> +       i_size_write(inode, offset);

hugetlb_reserve_pages() is used to reserve pages for shared mapping
and is used only for the size of mapping at the time of mmap().  We
shouldn't call this function when expanding hugetlb file.

- Ken
