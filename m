Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbXFDNFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbXFDNFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXFDNFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:05:24 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3588 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbXFDNFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:05:23 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 4 Jun 2007 06:05:22 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
In-Reply-To: <20070604014759.aaa3b051.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706040533210.30231@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
 <46633047.1020707@cosmosbay.com> <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
 <20070603230859.5000424d.akpm@linux-foundation.org> <20070604080537.GA22898@elte.hu>
 <20070604080941.GA23537@elte.hu> <20070604013449.ea3acca8.akpm@linux-foundation.org>
 <20070604084227.GA29446@elte.hu> <20070604014759.aaa3b051.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Andrew Morton wrote:

> a) Were IDR trees evaluated and if so, why were they rejected?
> 
> b) it's a bit disappointing that this new allocator is only usable for
>    one specific application.  We have a *lot* of places in the kernel which
>    want allocators of this type.  Many of them are open-coded and crappy. 
>    Some use IDR trees.
> 
>    If we're going to go and add a complete new allocator, it would be
>    good to position it as a library thing if poss.

Thank you for pointing me to that, Andrew. I didn't know about it (IDR 
trees).
It does not fit AFAICS. Locking should be handled extarnally (the files 
struct), must be RCU friendly (proper barriers) since it's used in 
lockless code, and must have flags associated to an allocation. And I'm 
leaving out the O(1) part, that for something like this, is just silly not 
to have it. This is really an array.



- Davide


