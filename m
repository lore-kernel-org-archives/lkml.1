Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbXLUHLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbXLUHLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXLUHLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:11:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42357 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbXLUHLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:11:06 -0500
Date: Fri, 21 Dec 2007 07:11:02 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm 09/43] compat_sys_ptrace
Message-ID: <20071221071102.GB4345@infradead.org>
References: <20071220115200.C767E26F98A@magilla.localdomain> <20071220115551.73EE026F98B@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220115551.73EE026F98B@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 03:55:51AM -0800, Roland McGrath wrote:
> This adds a generic definition of compat_sys_ptrace that calls
> compat_arch_ptrace, parallel to sys_ptrace/arch_ptrace.  Some
> machines needing this already define a function by that name.
> The new generic function is defined only on machines that
> put #define __ARCH_WANT_COMPAT_SYS_PTRACE into asm/ptrace.h.

Nice, we should have unified the compat ptrace code long ago.

Any chance you could make the ifdef symetric to the native ptrace
where an arch defines a symbol if it has it's own ptrace?

Also when prototyping something like this I was wondering whether we
really want a separate compat function.  Lots of the ptrace requests
mostly depend on the target processes abi, not the ptrace caller, so
maybe doing it like s390 and handle both in the same function might
actually be cleaner.  Anyway, that's probably something to worry about
later one the arch-specific compat ptrace implementations are gone.

