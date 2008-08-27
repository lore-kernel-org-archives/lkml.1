Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYH0A61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYH0A61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 20:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYH0A6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 20:58:17 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:34741 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbYH0A6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 20:58:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vV8rvHteS24/AqJN1XJntLqKD6uYEevKBi999MBwh5NzLyCXQTdWzoG1Tre6eYQWr1
         q8XFxDvfUXTjhdLJ4wdmxkyjFvOOdUPWSGC894bnnBpzbWaf+68/EnY+PelLyD+T4Fjd
         FDQUI+2pHfpIsLfr04sa9p02lRRcuajyD0RyU=
Message-ID: <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
Date: Tue, 26 Aug 2008 20:58:15 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "Adrian Bunk" <bunk@stusta.de>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-embedded@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
	 <200808261111.19205.rusty@rustcorp.com.au>
	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	 <20080826183051.GB10925@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	 <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	 <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
	 <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 7:47 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> If that matters, then so should the difference of 3-8 processes' kernel
> stack usage when you have a 4k/8k stack choice.

The savings part -financial ones- are not always realizable with the
way memory is priced/sized/fitted.
Savings in few Mb of Kernel stack are not necessarily going to allow
getting rid of a single memory chip of 64M or so.
Either that or embedded manufacturing/configurations are different
than the desktop world.

(If my device has 2 memory slots and my user space requires 100Mb
including kernel memory - I anyways have to put in 64Mx2 there to take
advantage of mass manufactured, general purpose memory - so no big
deal if I saved 1.2Mb in Kernel stack or not. And savings of 64Mb
Kernel memory are not feasible anyways to allow user space to work
with 64Mb.)

On the other hand reducing  user space memory usage on those devices
(not counting savings from kernel stack size) is a way more attractive
option.

And although you said in your later reply that Linux x86 with 4K
stacks should be more than usable - my experiences running a untainted
desktop/file server with 4K stack have been always disastrous XFS or
not.  It _might_ work for some well defined workloads but you would
not want to risk 4K stacks otherwise.

I understand the having 4K stack option as a non-default for very
specific workloads is a good idea but apart from that I think no one
else seems to bother with reducing stack sizes (by no one I mean other
OSes.)

Parag
