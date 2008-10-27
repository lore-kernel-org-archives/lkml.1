Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbYJ0IVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYJ0IVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYJ0IVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:21:46 -0400
Received: from gw.goop.org ([64.81.55.164]:40731 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYJ0IVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:21:46 -0400
Message-ID: <49057A15.7030007@goop.org>
Date: Mon, 27 Oct 2008 19:21:41 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, jens.axboe@oracle.com
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with BIOVEC_PHYS_MERGEABLE
References: <20081024143836K.fujita.tomonori@lab.ntt.co.jp>	<4902371A.5050303@goop.org> <20081027125139I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081027125139I.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> The block layer always done the physical merge if possible. We don't
> provide any kernel parameter to disable it.
>
> The iommu_bio_merge parameter had been used to enable the virtual
> merge. As I wrote, the virtual merge feature was completely
> removed. Effectively, the iommu_bio_merge parameter is meaningless
> now.
>   

Under Xen, pages which appear to be pseudo-physically adjacent are not 
necessarily really physically adjacent.  We need to hook 
BIOVEC_PHYS_MERGEABLE to prevent the bio layer from inappropriately 
merging requests across non-contiguous page boundaries.

    J
