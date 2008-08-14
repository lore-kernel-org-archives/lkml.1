Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYHNXDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYHNXDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYHNXDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:03:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbYHNXDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:03:40 -0400
Date: Thu, 14 Aug 2008 16:03:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: geert@linux-m68k.org, lachlan@sgi.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       linux-m68k@vger.kernel.org
Subject: Re: [GIT PULL] XFS update for 2.6.27-rc4
Message-Id: <20080814160327.bf2a2673.akpm@linux-foundation.org>
In-Reply-To: <20080814225130.GB19760@disturbed>
References: <20080813081147.8ECE258C52A8@chook.melbourne.sgi.com>
	<Pine.LNX.4.64.0808141738410.27466@anakin>
	<20080814225130.GB19760@disturbed>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 08:51:30 +1000
Dave Chinner <david@fromorbit.com> wrote:

> > |   CC      arch/m68k/kernel/asm-offsets.s
> > | In file included from linux/include/linux/mm_types.h:12,
> > |                  from linux/include/linux/sched.h:61,
> > |                  from linux/arch/m68k/kernel/asm-offsets.c:12:
> > | linux/include/linux/completion.h: In function 'try_wait_for_completion':
> > | linux/include/linux/completion.h:80: error: dereferencing pointer to incomplete type
> > | linux/include/linux/completion.h: In function 'completion_done':
> > | linux/include/linux/completion.h:99: error: dereferencing pointer to incomplete type
> > | make[3]: *** [arch/m68k/kernel/asm-offsets.s] Error 1
> > | make[2]: *** [prepare0] Error 2
> > | make[1]: *** [sub-make] Error 2
> > 
> > (cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/42080/)
> > 
> > Apparently there was not sufficient time between entering linux-next and
> > Linus' tree to notice this breakage before, while the original patch was already
> > posted on July 11...
> 
> It spent the time between then and now in the -mm tree. Seems
> like nobody is building m68k out of -mm.

I test m68k build regularly, but only allmodconfig.

Our (complexity(config system) * complexity(header files)) is so large
that compilation testing doesn't prove anything useful.  You just have
to check your homework very carefully and don earplugs for the
inevitable explosions.

> I'm out for the next 3 days, but it seems to me that the easiest fix
> is to move that code out of the header (i.e. uninline them) so the
> patch below is only compile tested on x86_64 - I've got to go load a
> trailer and get moving...

I'll give it a whizz on a few architectures, but it looks quite safe
from here.  It looks like the uninlining was desirable from a
size/speed POV anyway.


