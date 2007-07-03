Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbXGCEk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbXGCEk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 00:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXGCEkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 00:40:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57672
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbXGCEkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 00:40:17 -0400
Date: Mon, 02 Jul 2007 21:40:36 -0700 (PDT)
Message-Id: <20070702.214036.42772583.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org, greg@kroah.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 07/12] use a dynamic pool of sk_buffs to keep up with
 fast targets
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070702213636.9ca1d842.akpm@linux-foundation.org>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
	<bca4cec8ad679e8f8549cb78e012e54bfad1027e.1182883861.git.ecashin@coraid.com>
	<20070702213636.9ca1d842.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 2 Jul 2007 21:36:36 -0700

> My initial thought is that if there is a legitimate need for this
> new capability then it should be made available to other parts of
> the kernel rather than being private to the AEO driver.

Absolutely.

We even used to have something like this on a per-cpu basis but using
generic SLAB is so much better for caching and NUMA that we got rid of
that.

Every sk_buff private "quicklist" pool implementation you
see should essentially be NAK'd from the get go, it's
meaningless and if it's really needed one should investigate
why SKB allocations become such a problem instead of papering
over the issue. :-)
