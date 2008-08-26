Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbYHZXsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbYHZXsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYHZXsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:48:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbYHZXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:48:23 -0400
Date: Tue, 26 Aug 2008 16:47:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Parag Warudkar <parag.lkml@gmail.com>
cc: Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com>  <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>  <200808261111.19205.rusty@rustcorp.com.au>  <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org> 
 <20080826183051.GB10925@cs181140183.pp.htv.fi>  <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>  <20080826205916.GB11734@cs181140183.pp.htv.fi>  <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
 <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Parag Warudkar wrote:
> 
> This is something I never understood - embedded devices are not going
> to run more than a few processes and 4K*(Few Processes)
>  IMHO is not worth a saving now a days even in embedded world given
> falling memory prices. Or do I misunderstand?

Well, by that argument, 1% of kernel size doesn't matter either..

1% of a kernel for an embedded device is roughly 10-30kB or so depending 
on how small you make the configuration. 

If that matters, then so should the difference of 3-8 processes' kernel 
stack usage when you have a 4k/8k stack choice.

And they _all_ will have at least 3-8 processes on them. Even the simplest 
ones will tend to have many more.

			Linus
