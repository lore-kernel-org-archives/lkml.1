Return-Path: <linux-kernel-owner+w=401wt.eu-S933141AbXA2FaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbXA2FaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 00:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933142AbXA2FaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 00:30:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:20579 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933141AbXA2FaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 00:30:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=knGPRY9h8N49RgblxuG58fLboh8qaP0b8MjTF8bj1OqpJ6yt/MHPWz04UF4abHyDznQI25cE36e02T7MuFsD45ExLPzu8BclmlQon54CACruXL+0SiukTxC7RwC0kJCiFX6mvbMPodicJ2MkMVBEaMP3rRYptqMtw9hKm1c2sdE=
Message-ID: <4df04b840701282129h2334375ev74400a691f4d3a06@mail.gmail.com>
Date: Mon, 29 Jan 2007 13:29:58 +0800
From: "yunfeng zhang" <zyf.zeroos@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH 2.6.20-rc5 1/1] MM: enhance Linux swap subsystem
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0701242015090.1770@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4df04b840701212309l2a283357jbdaa88794e5208a7@mail.gmail.com>
	 <200701222300.41960.a1426z@gawab.com>
	 <4df04b840701222021w5e1aaab2if2ba7fc38d06d64b@mail.gmail.com>
	 <4df04b840701222108o6992933bied5fff8a525413@mail.gmail.com>
	 <Pine.LNX.4.64.0701242015090.1770@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You have an interesting idea of "simplifies", given
>  16 files changed, 997 insertions(+), 25 deletions(-)
> (omitting your Documentation), and over 7k more code.
> You'll have to be much more persuasive (with good performance
> results) to get us to welcome your added layer of complexity.

If the whole idea is deployed on Linux, following core objects should be erased
1) anon_vma.
2) pgdata::active/inactive list and relatted methods -- mark_page_accessed etc.
3) PrivatePage::count and mapcount. If core need to share the page, add PG_kmap
   flag. In fact, page::lru_list can safetly be erased too.
4) All cases should be from up to down, especially simplifies debug.

> Please make an effort to support at least i386 3level pagetables:
> you don't actually need >4GB of memory to test CONFIG_HIGHMEM64G.
> HIGHMEM testing shows you're missing a couple of pte_unmap()s,
> in pps_swapoff_scan_ptes() and in shrink_pvma_scan_ptes().

Yes, it's my fault.

> It would be nice if you could support at least x86_64 too
> (you have pte_low code peculiar to i386 in vmscan.c, which is
> preventing that), but that's harder if you don't have the hardware.

Um! Data cmpxchged should include access bit. And I have only x86 PC, memory <
1G. 3level pagetable code copied from Linux other functions.
