Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXC0VlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXC0VlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXC0VlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:41:05 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44077 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbXC0VlC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:41:02 -0400
Date: Tue, 27 Mar 2007 14:40:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Badari Pulavarty <pbadari@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.21-rc5-mm1
Message-Id: <20070327144031.ef75dd53.akpm@linux-foundation.org>
In-Reply-To: <46098CBE.7010807@cosmosbay.com>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
	<1175017173.16728.19.camel@dyn9047017100.beaverton.ibm.com>
	<20070327084838.34dc1b84.akpm@linux-foundation.org>
	<1175018270.16728.26.camel@dyn9047017100.beaverton.ibm.com>
	<20070327131214.656e1ad7.akpm@linux-foundation.org>
	<46098CBE.7010807@cosmosbay.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 23:29:34 +0200
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Andrew Morton a écrit :
> > 
> > The wheel spins around, slows then settles on.... 
> > time-smp-friendly-alignment-of-struct-clocksource.patch!
> > 
> > Presumably because the ____cacheline_aligned made vsyscall_gtod_data_t get
> > too big.  Or something.
> 
> Very strange, since here I have plenty of available room (256 bytes) :
> 
> ffffffffff600000 T vgettimeofday
> ffffffffff60004e t vsysc2
> ffffffffff600140 t vread_hpet
> ffffffffff600150 t vread_tsc
> ffffffffff600180 D __vsyscall_gtod_data
> ffffffffff600280 D __vgetcpu_mode
> ffffffffff6002c0 D __jiffies
> <lot of space (256 bytes)>
> ffffffffff600400 T vtime
> ffffffffff600413 t vsysc1
> ffffffffff600800 T vgetcpu
> ffffffffff600c00 T venosys_1
> 
> It must depends on the compiler, and/or CONFIG_XXX options...

Badari's config triggered it for me.

> Anyway, I think we can safely move __vgetcpu_mode & __jiffies to the 1024 
> bytes area dedicated to vgetcpu() implementation. This saves 128 bytes from 
> vsyscall_0 area.
> 
> Could we add this patch instead of dropping 
> time-smp-friendly-alignment-of-struct-clocksource.patch ?

When you tell me it works OK with Badari's config ;)
