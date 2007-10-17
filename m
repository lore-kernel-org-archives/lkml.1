Return-Path: <linux-kernel-owner+w=401wt.eu-S1760856AbXJQId0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856AbXJQId0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXJQIdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:33:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33066
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbXJQIdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:33:14 -0400
Date: Wed, 17 Oct 2007 01:33:25 -0700 (PDT)
Message-Id: <20071017.013325.74747630.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071017072149.GC5041@kernel.dk>
References: <20071017140747Q.fujita.tomonori@lab.ntt.co.jp>
	<20071017072149.GC5041@kernel.dk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 17 Oct 2007 09:21:49 +0200

> On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> > Commit 2c941a204070ab32d92d40318a3196a7fb994c00 looks incomplete. The
> > helper functions like prepare_sg() need to support sg chaining too.
> 
> Thanks Tomo, applied. I'll get this pushed out later today with any
> other sg chaining fallout we may see.

I'm still debugging crashes on sparc64 early on boot even with this
latest fix applied.

I think there are still problems in functions like fill_sg().

There is a lot of confusion involving loop termination.  sg_next()
gives you a NULL after the last entry, but tests have been changed
to compare against sg_last() which is likely not what we want for
those checks.

I'll try to figure it out, just a heads up...
