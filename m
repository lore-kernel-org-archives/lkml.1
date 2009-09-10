Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZIJGRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZIJGRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZIJGRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:17:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249AbZIJGRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:17:18 -0400
Date: Thu, 10 Sep 2009 08:13:47 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 0/2] __builtin_unreachable
Message-ID: <20090910061347.GD14664@tyan-ft48-01.lab.bos.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20090910015923.8FB628AE5F@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910015923.8FB628AE5F@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 06:59:23PM -0700, Roland McGrath wrote:
> The latest GCC has a better way than "for (;;)" to indicate that a code
> path cannot be reached due to reasons the compiler doesn't understand (such
> as code in an asm).  These patches provide UNREACHABLE() as a macro to hide
> the details of this, and then use it for the BUG() macro on x86, saving
> some dead code otherwise generated.
> 
> Other arch's BUG() may want to this too instead of "for (;;)" or __builtin_trap.

Just instead of for (;;) (or any place where an asm never returns). 
__builtin_trap () shouldn't be replaced - __builtin_unreachable () just says
that the location is never reachable, so everything after it not reachable
through other ways can be optimized out - while __builtin_trap () emits an
instruction that traps and then assumes anything after it is unreachable.

Also, I wonder if Fedora/RHEL specific GCC backport is desirable to be
handled in upstream kernel (i.e. whether compiler-gcc4.h shouldn't enable it
just for GCC 4.5+) and Fedora/RHEL should patch it for our backport.

	Jakub
