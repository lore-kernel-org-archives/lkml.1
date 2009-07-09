Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZGIIDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZGIIDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:03:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZGIICq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:02:46 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:17099 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbZGIICn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:02:43 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dave Jones <davej@redhat.com>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <20090709043931.GA11391@redhat.com>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com>
	 <1246980836.9777.5.camel@twins>
	 <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com>
	 <1246981444.9777.11.camel@twins>
	 <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com>
	 <1246982101.9777.15.camel@twins> <20090708172248.GB2521@redhat.com>
	 <1247078164.16156.18.camel@laptop>  <20090709043931.GA11391@redhat.com>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 10:02:36 +0200
Message-Id: <1247126556.9777.323.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 00:39 -0400, Dave Jones wrote:
> On Wed, Jul 08, 2009 at 08:36:04PM +0200, Peter Zijlstra wrote:
>  > Looking at a lockdep dump hch gave me I can see that that is certainly
>  > possible, I see tons of very deep callchains.
>  > 
>  > /me wonders if we're getting significantly deeper..
> 
> Looking at /proc/lockdep, I'm curious..
> Take a look at http://davej.fedorapeople.org/lockdep
> scroll down to c12c0924
> 
> What's up with all those old_style_spin_init's ?

What kernel are you running? Does your lib/dma_debug.c:dma_debug_init()
have spin_lock_init() in that HASH_SIZE loop?

If so, then there's someone else doing silly, if not, you seriously need
to upgrade your kernel because you're running something ancient,
like .30 :-)

