Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZJLKQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZJLKQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZJLKQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:16:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41007
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbZJLKQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:16:33 -0400
Date: Mon, 12 Oct 2009 03:16:28 -0700 (PDT)
Message-Id: <20091012.031628.98420072.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: ngupta@vflare.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091012100023.GC29310@n2100.arm.linux.org.uk>
References: <20091012090710.GA29310@n2100.arm.linux.org.uk>
	<20091012.023744.157085851.davem@davemloft.net>
	<20091012100023.GC29310@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Mon, 12 Oct 2009 11:00:23 +0100

> The problem which has been identified is that when flush_dcache_page() is
> called, there is a mapping, and so the page is marked for lazy flushing.
> However, by the time update_mmu_cache() gets called, the mapping has gone
> and so update_mmu_cache() does nothing.

Now I understand, thanks.

Ok, I'll remove the mapping check from the sparc64 flush_dcache()
function, seems the right thing to do.

