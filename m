Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYGKTmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYGKTmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYGKTlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:41:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47774
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754255AbYGKTlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:41:53 -0400
Date: Fri, 11 Jul 2008 12:41:52 -0700 (PDT)
Message-Id: <20080711.124152.247767508.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: mpatocka@redhat.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080711201558J.fujita.tomonori@lab.ntt.co.jp>
References: <20080711152054C.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0807110649510.16550@engineering.redhat.com>
	<20080711201558J.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 11 Jul 2008 20:15:52 +0900

> On Fri, 11 Jul 2008 06:52:09 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > On Fri, 11 Jul 2008, FUJITA Tomonori wrote:
> > 
> > > Yeah, IOMMUs can't guarantee that. The majority of architectures set
> > > BIO_VMERGE_BOUNDARY to 0 so they don't hit this, I think.
> > 
> > Yes, the architectures without IOMMU don't hit this problem.
> 
> I meant that even if some architectures support IOMMUs, they set
> BIO_VMERGE_BOUNDARY to 0.

Keep in mind that these settings were added long before
we supported segment boundary restrictions.

Someone added code to handle segment boundaries, but didn't
fix any of the block I/O layer infrastructure :-)

Several platforms that have IOMMU but set these values to zero
actually did so for another reason.  They considered being
required to always merge page-adjacent mappings virtually too
strong a requirement to meet %100 of the time.
