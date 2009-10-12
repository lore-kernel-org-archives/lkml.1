Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZJLROQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZJLROQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZJLROP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:14:15 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45167 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZJLROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:14:14 -0400
Message-ID: <4AD36376.60007@vflare.org>
Date: Mon, 12 Oct 2009 22:42:22 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
References: <1255337423-3158-1-git-send-email-ngupta@vflare.org> <20091012090710.GA29310@n2100.arm.linux.org.uk> <20091012.023744.157085851.davem@davemloft.net> <20091012100023.GC29310@n2100.arm.linux.org.uk> <Pine.LNX.4.64.0910121634170.7327@sister.anvils> <20091012170312.GB9453@flint.arm.linux.org.uk>
In-Reply-To: <20091012170312.GB9453@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2009 10:33 PM, Russell King wrote:
> On Mon, Oct 12, 2009 at 05:09:53PM +0100, Hugh Dickins wrote:
>> Sorry to muddy the waters on this, if you and Dave are sure that
>> you have the right fix, down in your architectures, and that fix
>> isn't going to hurt your performance significantly.
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


Presented so clearly by Russell and this is exactly what I meant, though
the example just focused on some particular swap case which I happen to
stumble upon while working on something similar.

Thanks,
Nitin
