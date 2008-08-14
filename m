Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYHNPpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYHNPpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYHNPpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:45:22 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:54148 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYHNPpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:45:21 -0400
Date: Thu, 14 Aug 2008 17:45:18 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lachlan McIlroy <lachlan@sgi.com>, David Chinner <david@fromorbit.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [GIT PULL] XFS update for 2.6.27-rc4
In-Reply-To: <20080813081147.8ECE258C52A8@chook.melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0808141738410.27466@anakin>
References: <20080813081147.8ECE258C52A8@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Lachlan McIlroy wrote:
> The following changes since commit 30a2f3c60a84092c8084dfe788b710f8d0768cd4:
>   Linus Torvalds (1):
>         Linux 2.6.27-rc3
> 
> are available in the git repository at:
> 
>   git://oss.sgi.com:8090/xfs/linux-2.6 master
> 
> David Chinner (12):
>       [XFS] extend completions to provide XFS object flush requirements

This change (commit 39d2f1ab2a36ac527a6c41cfe689f50c239eaca3) seems to
have broken the m68k build:

|   CC      arch/m68k/kernel/asm-offsets.s
| In file included from linux/include/linux/mm_types.h:12,
|                  from linux/include/linux/sched.h:61,
|                  from linux/arch/m68k/kernel/asm-offsets.c:12:
| linux/include/linux/completion.h: In function 'try_wait_for_completion':
| linux/include/linux/completion.h:80: error: dereferencing pointer to incomplete type
| linux/include/linux/completion.h: In function 'completion_done':
| linux/include/linux/completion.h:99: error: dereferencing pointer to incomplete type
| make[3]: *** [arch/m68k/kernel/asm-offsets.s] Error 1
| make[2]: *** [prepare0] Error 2
| make[1]: *** [sub-make] Error 2

(cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/42080/)

Apparently there was not sufficient time between entering linux-next and
Linus' tree to notice this breakage before, while the original patch was already
posted on July 11...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
