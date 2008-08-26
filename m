Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYHZVFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYHZVFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYHZVFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:05:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbYHZVFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:05:34 -0400
Date: Tue, 26 Aug 2008 14:04:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
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
In-Reply-To: <20080826205916.GB11734@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
 <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826205916.GB11734@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Adrian Bunk wrote:
> 
> If you think we have too many stacksize problems I'd suggest to consider 
> removing the choice of 4k stacks on i386, sh and m68knommu instead of 
> using -fno-inline-functions-called-once:

Don't be silly. That makes the problem _worse_.

We're much better off with a 1% code-size reduction than forcing big 
stacks on people. The 4kB stack option is also a good way of saying "if it 
works with this, then 8kB is certainly safe".

And embedded people (the ones that might care about 1% code size) are the 
ones that would also want smaller stacks even more!

		Linus
