Return-Path: <linux-kernel-owner+w=401wt.eu-S1763789AbXGVTzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763789AbXGVTzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 15:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760593AbXGVTzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 15:55:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760203AbXGVTzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 15:55:35 -0400
Date: Sun, 22 Jul 2007 21:55:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
Message-ID: <20070722195532.GA1432@one.firstfloor.org>
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <20070720212741.GB565@one.firstfloor.org> <46A12A3A.4020305@zytor.com> <20070722091826.GA28313@one.firstfloor.org> <46A39C64.9070301@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A39C64.9070301@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 11:05:24AM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >> The main reason is that everyone seems to invoke it either incorrectly
> > Where is it incorrect? 
> 
> Using "r" or "m" (as opposed as "+m") gives gcc the wrong dependency
> information, and it could, at least in theory, cause memory references
> to be moved around it -- especially when using "r".

That doesn't sound correct. Taking the address should be like an escaping
pointer and equivalent to read/write and effectively disable optimizations
on this memory.

-Andi
