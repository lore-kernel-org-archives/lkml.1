Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbZDCIzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbZDCIzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZDCIzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:55:24 -0400
Received: from aun.it.uu.se ([130.238.12.36]:35829 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbZDCIzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:55:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18901.52910.795773.284166@pilspetsen.it.uu.se>
Date: Fri, 3 Apr 2009 10:54:06 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Stefani Seibold <stefani@seibold.net>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Engel <joern@logfs.org>
Subject: Re: Detailed Stack Information Patch [2/3]
In-Reply-To: <1238745668.8735.4.camel@matrix>
References: <1238511507.364.62.camel@matrix>
	<20090401193639.GB12316@elte.hu>
	<1238707547.3882.24.camel@matrix>
	<18901.48028.862826.66492@pilspetsen.it.uu.se>
	<1238745668.8735.4.camel@matrix>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold writes:
 > Am Freitag, den 03.04.2009, 09:32 +0200 schrieb Mikael Pettersson:
 > > Stefani Seibold writes:
 > >  > I think a user space daemon will be the a good way if the /proc/*/maps
 > >  > or /proc/*/stack will provide the following information:
 > >  > 
 > >  > - start address of the stack
 > >  > - current address of the stack pointer
 > >  > - highest used address in the stack
 > > 
 > > You're assuming
 > > 1. a thread has exactly one stack
 > > 2. the stack is a single unbroken area
 > > 3. the kernel knows the location of this area
 > > 
 > > None of these assumptions are necessarily valid, esp. in
 > > the presence of virtualizers, managed runtimes, or mixed
 > > interpreted/JIT language implementations.
 > 
 > We are talking about the kernel view. And from this point a thread has
 > only one stack and it is a single mapped continuous area. There are only
 > one exception and that is the sigaltstack().

So you're proposing to have the kernel export data which,
while accurate from the kernel's limited view, may be
arbitrarily inaccurate for the user-space process in question?

Also I'm not sure you even need a kernel extension for the
optimistic case of a single simple stack. ptrace to get stack
pointer then scan /proc/$tid/maps to identify the corresponding
mapping should give the same information, no?
