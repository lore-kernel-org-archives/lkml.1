Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbYJQQlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbYJQQlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYJQQlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:41:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbYJQQlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:41:19 -0400
Date: Fri, 17 Oct 2008 12:41:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: xfs@oss.sgi.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081017164116.GA17375@infradead.org>
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 04:43:07PM +0400, Alexander Beregalov wrote:
> It is SMP x86_64, rootfs is on XFS

The message comes from code in XFS, but I really wonder where the atomic
context comes from.  xfs_iget_core has a few changes in the tree pulled
into todays Linux-next, but it's still missing the recent updates
redoing this area completely.  In some ways it looks like this process
has the the atomic context flag left pending somewhere, but that should
also trigger warnings on the VFS locks like i_mutex.

Very misterious.

IS there a specific workload you can reproduce this with?

