Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYGAHkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYGAHkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYGAHkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:40:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39250 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYGAHkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:40:36 -0400
Date: Tue, 1 Jul 2008 03:40:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] fat: Fix VFAT_IOCTL_READDIR_xxx and cleanup for
	userland
Message-ID: <20080701074033.GB30362@infradead.org>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp> <129170883e848699cff211608.ps@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <129170883e848699cff211608.ps@mail.parknet.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 11:57:03AM +0900, OGAWA Hirofumi wrote:
> 
> "struct dirent" is a kernel type here, but is a **different type** in 
> userspace!  This means both the structure and the IOCTL number is wrong!
> 
> So, this adds new "struct __fat_dirent" to generate correct IOCTL
> number.  And kernel stuff moves to under __KERNEL__.

Given that the current version can't actually work without defininig
it's own dirent and thus ioctl number symbolic name I wonder if these
ioctls are used at all?  They must have been completely untested for
a while, and I suspect we'd be better off just removing them.

