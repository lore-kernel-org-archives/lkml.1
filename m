Return-Path: <linux-kernel-owner+w=401wt.eu-S1761953AbXKIBpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953AbXKIBpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 20:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbXKIBpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 20:45:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48820
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761540AbXKIBpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 20:45:24 -0500
Date: Thu, 08 Nov 2007 15:24:08 -0800 (PST)
Message-Id: <20071108.152408.157342087.davem@davemloft.net>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ak@suse.de,
       mathieu.desnoyers@polymtl.ca
Subject: Re: Some interesting observations when trying to optimize vmstat
 handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711081141180.9694@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711081141180.9694@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 8 Nov 2007 11:58:58 -0800 (PST)

> The problem with cmpxchg_local here is that the differential has to
> be read before we execute the cmpxchg_local. So the cacheline is
> acquired first in read mode and then made exclusive on executing the
> cmpxchg_local.

I bet this can be defeated by prefetching for a write before
the read, but of course this won't help if the read is
being used to conditionally avoid the cmpxchg_local but I don't
think that's what you're trying to do here.

I've always wanted to add a write prefetch at the beginning of all of
the sparc64 atomic operation primitives because of this problem.
I just never got around to measuring if it's worthwhile or not.
