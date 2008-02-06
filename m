Return-Path: <linux-kernel-owner+w=401wt.eu-S932909AbYBFXTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909AbYBFXTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932660AbYBFXS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:18:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49523
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932655AbYBFXS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:18:26 -0500
Date: Wed, 06 Feb 2008 15:18:55 -0800 (PST)
Message-Id: <20080206.151855.136436571.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: tomof@acm.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: more iommu sg merging fallout
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080207081236V.fujita.tomonori@lab.ntt.co.jp>
References: <20080205.204138.107606929.davem@davemloft.net>
	<20080207081236V.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 07 Feb 2008 08:12:36 +0900

> Really sorry about it.

I am happy to test patches you send to me in the future :-)

> PARISC, Alpha, and IA64 IOMMUs use the two-pass algorithm like SPARC
> but their first pass decides how to merge sg entires (and stores that
> information in the sg entries), then the second pass simpliy follows
> it (Hopefully I understand these IOMMUs correctly, or else I break
> them too).

For now I've removed all of the merging code from the sparc64 IOMMU
support so that other users do not get corrupt filesystems.  It
basically mimicks how the intel-iommu code works, ie. no attempts to
merge anything.

I intend to put merging back in, perhaps something similar to
powerpc's merging logic but without the expensive (in my opinion)
IOMMU allocation every loop.  I think it is better to determine the
segment breaks in one pass, allocate that many IOMMU entries in one
allocation, then fill them all in.

Ideally, we should have some generic code that does all of this.
Then you would only need to test one implementation.

It is definitely doable and increasingly necessary as we have so
many reimplementations of what is essentially identical core code.

