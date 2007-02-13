Return-Path: <linux-kernel-owner+w=401wt.eu-S1750699AbXBMOnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750699AbXBMOnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750700AbXBMOnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:43:39 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:57358 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699AbXBMOni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:43:38 -0500
Subject: Re: [patch] (2nd try)  add epoll compat code to kernel/compat.c ...
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
In-Reply-To: <20070213153525.c1440cff.sfr@canb.auug.org.au>
References: <Pine.LNX.4.64.0702111615340.24568@alien.or.mcafeemobile.com>
	 <20070213153525.c1440cff.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 08:43:05 -0600
Message-Id: <1171377785.3382.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 15:35 +1100, Stephen Rothwell wrote:
> OK, I have thought about this some more and I *think* the only
> architecture that needs compat_sys_epoll_ctl or compat_sys_epoll_wait is
> ia64 where the 64 bit version of struct epoll_event is different from the
> 32 bit version.  On x86_64, the struct is explictly packed (so it is the
> same as the 32 bit version) and on all the other 64 bit architectures the
> alignment of the u64 is the same as the equivalent 32 bit version.
> 
> Since ia64 already has its own version of these two, we only have to
> worry about epoll_pwait and then the struct epoll_event is only a problem
> for ia64.
> 
> Am I right?  (I have cc'd linux-arch for guidance.)

Not for parisc at the instruction level.  In narrow mode (32 bit mode),
a u64 load has to be done by two 32 bit loads which gives it a 4 byte
alignment requirement.  In wide mode (64 bit mode) the 64 bit load
instruction explicitly requires 8 byte alignment, so our u64 alignment
requirements are different.  However, this is from the machine code
point of view.  I can't say that gcc doesn't enforce an artificial 8
byte alignment of u64 in narrow mode, so I'll defer to the gcc experts
on that one.

James


