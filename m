Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbYHZSsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbYHZSsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbYHZSsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:48:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757870AbYHZSsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:48:03 -0400
Date: Tue, 26 Aug 2008 11:47:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <20080826183051.GB10925@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
 <20080826183051.GB10925@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Adrian Bunk wrote:
> 
> I added "-fno-inline-functions-called-once -fno-early-inlining" to 
> KBUILD_CFLAGS, and (with gcc 4.3) that increased the size of my kernel 
> image by 2%.

Btw, did you check with just "-fno-inline-functions-called-once"?

The -fearly-inlining decisions _should_ be mostly right. If gcc sees early 
that a function is so small (even without any constant propagation etc) 
that it can be inlined, it's probably right. 

The inline-functions-called-once thing is what causes even big functions 
to be inlined, and that's where you find the big downsides too (eg the 
stack usage).

			Linus
