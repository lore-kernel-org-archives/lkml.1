Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXCZUSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXCZUSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbXCZUSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:18:10 -0400
Received: from mylar.outflux.net ([69.93.193.226]:53296 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbXCZUSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:18:08 -0400
Date: Mon, 26 Mar 2007 13:17:43 -0700
From: Kees Cook <kees@outflux.net>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Marcus Meissner <meissner@suse.de>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@codemonkey.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: revert PIE randomization?
Message-ID: <20070326201743.GZ22797@outflux.net>
References: <20070321181730.GV22797@outflux.net> <Pine.LNX.4.64.0703211940370.24602@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703211940370.24602@blonde.wat.veritas.com>
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 08:01:50PM +0000, Hugh Dickins wrote:
> It was in doing kernel builds that I hit it, nothing special: an
> overnight cycle of kernel building would collapse in a few hours.
> openSUSE 10.2.

I wonder it was the combination of the base addr randomization patch and 
something specific to the openSuSE loader that was sparking the 
failures?  I ran about 22 million execs on Ubuntu Feisty (patched to 
re-include the base addr randomization), with a PIE bash, and never saw 
it.  Hmpf.

> Andi would tell definitively, but I guess it's merely that with so
> much more address space to play with, x86_64 can divide up that space
> more satisfactorily.
> 
> But don't be misled: try "ulimit -s unlimited" and I expect you'll
> find i386 allocating mmap addresses (hence libraries) from the
> opposite end, below ELF_ET_DYN_BASE.

Is there any explicitly documented per-arch "here is the memory layout 
of a process"?  I haven't been able to find anything like this.  I 
suspect it would be a good reference to have; so if no one has any 
hints, I'll try to get something written up.

-- 
Kees Cook                                            @outflux.net
