Return-Path: <linux-kernel-owner+w=401wt.eu-S1751246AbZHSFsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbZHSFsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 01:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZHSFsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 01:48:11 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:12309 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZHSFsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 01:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fYE2DbFPtvAQPpJJcKljiawenoXPWQcoKxX12oIs9jaiLzbd6eFc8p4z4Zap7nYD5a
         S9F2NnlqFxyzPcsBWrL18myWu5EBPd/GJDt5q+ju5zVa2FwCcYOeIDsBbDHrUCz6QU3L
         mJRA5IHk0WXGuL+12+4pNIEE6norf880HGVs4=
MIME-Version: 1.0
In-Reply-To: <56e00de0908180329p2a37da3fp43ddcb8c2d63336a@mail.gmail.com>
References: <alpine.LFD.2.00.0908172317470.32114@casper.infradead.org>
	 <56e00de0908180329p2a37da3fp43ddcb8c2d63336a@mail.gmail.com>
Date: Wed, 19 Aug 2009 17:48:11 +1200
Message-ID: <202cde0e0908182248we01324em2d24b9e741727a7b@mail.gmail.com>
Subject: Re: [PATCH 0/3]HTLB mapping for drivers (take 2)
From: Alexey Korolev <akorolex@gmail.com>
To: Eric Munson <linux-mm@mgebm.net>
Cc: Alexey Korolev <akorolev@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>
> It sounds like this patch set working towards the same goal as my
> MAP_HUGETLB set.  The only difference I see is you allocate huge page
> at a time and (if I am understanding the patch) fault the page in
> immediately, where MAP_HUGETLB only faults pages as needed.  Does the
> MAP_HUGETLB patch set provide the functionality that you need, and if
> not, what can be done to provide what you need?
>
> Eric
>
Thanks a lot for willing to help. I'll be much appreciate if you have
an interesting idea how HTLB mapping for drivers can be done.

It is better to describe use case in order to make it clear what needs
to be done.
Driver provides mapping of device DMA buffers to user level
applications. User level applications process the data.
Device is using a master DMA to send data to the user buffer, buffer
size can be >1GB and performance is very important. (So huge pages
mapping really makes sense.)

In addition we have to mention that:
1. It is hard for user to tell how much huge pages needs to be
reserved by the driver.
2. Devices add constrains on memory regions. For example it needs to
be contiguous with in the physical address space. It is necessary to
have ability to specify special gfp flags.
3 The HW needs to access physical memory before the user level
software can access it. (Hugetlbfs picks up pages on page fault from
pool).
It means memory allocation needs to be driven by device driver.

Original idea was: create hugetlbfs file which has common mapping with
device file. Allocate memory. Populate page cache of hugetlbfs file
with allocated pages.
When fault occurs, page will be taken from page cache and then
remapped to user space by hugetlbfs.

Another possible approach is described here:
http://marc.info/?l=linux-mm&m=125065257431410&w=2
But currently not sure  will it work or not.


Thanks,
Alexey
