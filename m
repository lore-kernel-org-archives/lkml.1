Return-Path: <linux-kernel-owner+w=401wt.eu-S933353AbXCMVHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbXCMVHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbXCMVHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:07:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58371
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933353AbXCMVHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:07:23 -0400
Date: Tue, 13 Mar 2007 14:07:22 -0700 (PDT)
Message-Id: <20070313.140722.72711732.davem@davemloft.net>
To: mpm@selenic.com
Cc: jeremy@goop.org, nickpiggin@yahoo.com.au, akpm@linux-foundation.org,
       clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070313202125.GO10394@waste.org>
References: <20070313200313.GG10459@waste.org>
	<45F706BC.7060407@goop.org>
	<20070313202125.GO10394@waste.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Tue, 13 Mar 2007 15:21:25 -0500

> Because the fan-out is large, the bulk of the work is bringing the last
> layer of the tree into cache to find all the pages in the address
> space. And there's really no way around that.

That's right.

And I will note that historically we used to be much worse
in this area, as we used to walk the page table tree twice
on address space teardown (once to hit the PTE entries, once
to free the page tables).

Happily it is a one-pass algorithm now.

But, within active VMA ranges, we do have to walk all
the bits at least one time.
