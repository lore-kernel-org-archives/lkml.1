Return-Path: <linux-kernel-owner+w=401wt.eu-S933332AbXCUSSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbXCUSSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbXCUSSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:18:15 -0400
Received: from mylar.outflux.net ([69.93.193.226]:35830 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332AbXCUSSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:18:05 -0400
Date: Wed, 21 Mar 2007 11:17:30 -0700
From: Kees Cook <kees@outflux.net>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Marcus Meissner <meissner@suse.de>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@codemonkey.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: revert PIE randomization?
Message-ID: <20070321181730.GV22797@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701062005001.22171@blonde.wat.veritas.com>
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

Hugh Dickins said:
> Inconsistency detected by ld.so: rtld.c: 1217: dl_main:
>  Assertion `_rtld_local._dl_rtld_map.l_libname' failed!

I'm trying to reproduce the problem you saw (so that I can then test 
your proposed fix).  However, I haven't had any luck.  I've got a 
pie-compiled version of bash, and I've been running it in a loop for a 
while now with the original randomization patch.  (I can clearly see the 
base address bouncing around.)

I'm at just over 10 million exec's, and I haven't hit the problem.  :(

Do you have any clues on how to trigger this more reliably?

Also, does anyone have any thoughts on why x86 uses a ELF_ET_DYN_BASE 
below the libraries, where as x86_64 uses one above them?  From this, 
I'd expect x86_64 to collide with the libraries at times.  I need more 
help understanding the memory layouts, I guess.  :)

Thanks,

-- 
Kees Cook                                            @outflux.net
