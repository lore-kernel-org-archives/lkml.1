Return-Path: <linux-kernel-owner+w=401wt.eu-S1764423AbXGXSO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764423AbXGXSO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763872AbXGXSOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:14:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764148AbXGXSOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:14:38 -0400
Date: Tue, 24 Jul 2007 11:14:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc1: BUG_ON in kmap_atomic_prot()
In-Reply-To: <20070724175951.GC6019@stusta.de>
Message-ID: <alpine.LFD.0.999.0707241113180.3607@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <20070723183839.GA5874@martell.zuzino.mipt.ru> <20070723190152.GA5755@martell.zuzino.mipt.ru>
 <20070723132431.42afbae8.akpm@linux-foundation.org>
 <20070723204045.GD5755@martell.zuzino.mipt.ru> <20070723210153.GA5753@martell.zuzino.mipt.ru>
 <20070723141137.171e4ac1.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707231415511.3607@woody.linux-foundation.org>
 <20070724175951.GC6019@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jul 2007, Adrian Bunk wrote:
> 
> buffered_rmqueue() and prep_new_page() are static functions with only 
> one caller each, and for the normal non-debug case it's a really nice 
> optimization to have them inlined automatically.

I'm not at all sure I agree.

Inlining big functions doesn't actually tend to generally generate any 
better code, so if gcc's logic is "single callsite - always inline", then 
that logic is likely not right.

		Linus
