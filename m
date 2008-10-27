Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbYJ0EDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbYJ0EDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 00:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYJ0EDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 00:03:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:36269 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbYJ0EDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 00:03:09 -0400
Date: Mon, 27 Oct 2008 12:52:29 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu,
       jens.axboe@oracle.com
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with
 BIOVEC_PHYS_MERGEABLE
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4902371A.5050303@goop.org>
References: <20081024143836K.fujita.tomonori@lab.ntt.co.jp>
	<4902371A.5050303@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081027125139I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 13:59:06 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The bio common code no longer uses BIO_VMERGE_BOUNDARY, so replace it
> with BIOVEC_PHYS_MERGEABLE.  Also make iommu_bio_merge a boolean
> rather than a size, as befits its use.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>

This doesn't look correct.

The block layer always done the physical merge if possible. We don't
provide any kernel parameter to disable it.

The iommu_bio_merge parameter had been used to enable the virtual
merge. As I wrote, the virtual merge feature was completely
removed. Effectively, the iommu_bio_merge parameter is meaningless
now.
