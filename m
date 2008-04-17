Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbYDQHJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbYDQHJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYDQHJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:09:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57363
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753433AbYDQHJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:09:45 -0400
Date: Thu, 17 Apr 2008 00:09:46 -0700 (PDT)
Message-Id: <20080417.000946.44234467.davem@davemloft.net>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [LMB][2/2] Restructure allocation loops to avoid unsigned
 underflow
From: David Miller <davem@davemloft.net>
In-Reply-To: <18432.18107.854417.50018@cargo.ozlabs.ibm.com>
References: <18432.18107.854417.50018@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Sat, 12 Apr 2008 15:20:59 +1000

> There is a potential bug in __lmb_alloc_base where we subtract `size'
> from the base address of a reserved region without checking whether
> the subtraction could wrap around and produce a very large unsigned
> value.  In fact it probably isn't possible to hit the bug in practice
> since it would only occur in the situation where we can't satisfy the
> allocation request and there is a reserved region starting at 0.
> 
> This fixes the potential bug by breaking out of the loop when we get
> to the point where the base of the reserved region is less than the
> size requested.  This also restructures the loop to be a bit easier to
> follow. 
> 
> The same logic got copied into lmb_alloc_nid_unreserved, so this makes
> a similar change there.  Here the bug is more likely to be hit because
> the outer loop  (in lmb_alloc_nid) goes through the memory regions in
> increasing order rather than decreasing order as __lmb_alloc_base
> does, and we are therefore more likely to hit the case where we are
> testing against a reserved region with a base address of 0.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>

This looks great, thanks for doing this work Paul.

I'll try to find some cycles to validate these changes alongside
the pending sparc64 NUMA changes I have.
