Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbZJMCJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbZJMCJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758697AbZJMCJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:09:32 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:60980 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbZJMCJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:09:31 -0400
Date: Tue, 13 Oct 2009 11:07:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       David Miller <davem@davemloft.net>, Nitin Gupta <ngupta@vflare.org>,
       Nick Piggin <npiggin@suse.de>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
Message-ID: <20091013020752.GB5736@linux-sh.org>
References: <1255337423-3158-1-git-send-email-ngupta@vflare.org> <20091012090710.GA29310@n2100.arm.linux.org.uk> <20091012.023744.157085851.davem@davemloft.net> <20091012100023.GC29310@n2100.arm.linux.org.uk> <Pine.LNX.4.64.0910121634170.7327@sister.anvils> <20091012170312.GB9453@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012170312.GB9453@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 06:03:12PM +0100, Russell King wrote:
> On Mon, Oct 12, 2009 at 05:09:53PM +0100, Hugh Dickins wrote:
> > Sorry to muddy the waters on this, if you and Dave are sure that
> > you have the right fix, down in your architectures, and that fix
> > isn't going to hurt your performance significantly.
> 
> If I look at the issue from this point of view:
> 
> - we are using PG_arch_1 to delay cache handling for the page
> 
> - if PG_arch_1 is set on a page, we set it explicitly because we
>   didn't do some flushing between the allocation of the page and
>   mapping it into userspace
> 
> - if a page with PG_arch_1 set ever gets to userspace, this can
>   only be because we did the lazy flushing thing
> 
> I don't see that there should have been any bearing on whether a page
> has a mapping or not when we get to update_mmu_cache.  The issue here
> is that > if PG_arch_1 is set on a page, then we didn't flush it at
> the time when we believed it was appropriate to do so. <
> 
> Tell me I'm wrong (having only just sent it to Linus...)
> 
Having looked at the ARM fix, in the !mapping case do you not need the
I-cache flush on vma->vm_flags & VM_EXEC? Or is the presumption that
flush_icache_page()-type action doesn't need to be undertaken by
flush_dcache_page()/update_mmu_cache() when there is no page_mapping()?
