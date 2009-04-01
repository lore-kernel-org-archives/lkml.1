Return-Path: <linux-kernel-owner+w=401wt.eu-S1765418AbZDAASy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765418AbZDAASy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbZDAASe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:18:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:33746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764751AbZDAASd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:18:33 -0400
Message-ID: <49D2B209.9060000@kernel.org>
Date: Wed, 01 Apr 2009 09:15:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase> <49CA1AC3.9080908@kernel.org> <20090325150035.541e707a@skybase> <49CA3C2C.5030702@kernel.org> <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0903311208110.17960@qirst.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 00:15:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Christoph Lameter wrote:
> I reviewed the new per cpu allocator. Quite extensive work. Found two
> issues that I would like to have addressed. But basically:
> 
> Reviewed-by: Christoph Lameter <cl@linux.com>

Thanks.

> Two issues
> 
> 1. Lot of unnecessary use of __read_mostly for local static variables that
> are not on the hotpath. Patch follows in this message.

Hmmm... Those are basically read-only vars once initialization is
complete.  IIUC, __read_mostly just puts the tagged variables into a
separate segment so that they don't have to worry about cacheline
bouncing.  Is there any reason to remove __read_mostly?  Or is it just
that it's mostly superflous?

> 2. rbtree is not necessary since we can link back through the an available
> field in struct page. Patch in next message.

Ah... nice.  I was thinking about adding ->private pointer to the
vmalloc structure but if page already has the space, all the better.

Thanks.

-- 
tejun
