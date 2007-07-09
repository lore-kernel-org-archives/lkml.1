Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbXGIGgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbXGIGgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 02:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbXGIGg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 02:36:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:39461 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbXGIGg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 02:36:26 -0400
Subject: Re: removing flush_tlb_mm as a generic hook ?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1183952874.3388.349.camel@localhost.localdomain>
References: <1183952874.3388.349.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 16:36:21 +1000
Message-Id: <1183962981.5961.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 13:47 +1000, Benjamin Herrenschmidt wrote:
> Hi folks !
> 
> While toying around with various MM callbacks, I found out that
> flush_tlb_mm() as a generic hook provided by the archs has been mostly
> obsoleted by the mmu_gather stuff.

And since life is always better with patches... here are two that
do fork and proc/fs/task_mmu. There should be an improvement on archs
like hash-table based ppc32 where flush_tlb_mm() currently has to walk
the page tables, which means an additional walk pass in fork. With this
patch, there will be only one pass, and it will only hit the pages that
have actually been marked RO.

I need to do some proper testing, but in copy to this, I'm posting the
patches anyway for review / comments.

Ben.


