Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbYAHJhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbYAHJhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYAHJgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:36:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42661 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbYAHJgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:36:51 -0500
Date: Tue, 8 Jan 2008 10:35:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Reiser <jreiser@BitWagon.com>
Cc: Paul Mackerras <paulus@samba.org>, Hirokazu Takata <takata@linux-m32r.org>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Mikael Starvik <starvik@axis.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: STT_FUNC for assembler checksum and semaphore ops
Message-ID: <20080108093558.GG27671@elte.hu>
References: <47826019.9040607@BitWagon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47826019.9040607@BitWagon.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Reiser <jreiser@BitWagon.com> wrote:

> Dear $ARCH Maintainers,
> 
> This patch adds Elf32_Sym .st_info (STT_FUNC) and .st_size for 
> hand-coded checksum and semaphore subroutines.  I needed this info 
> when writing a static analyzer for stack depth [grovel over ./vmlinux] 
> on the um (UserModeLinux) $ARCH for i386.  The changes work on i386.  
> Other $ARCH are analogous but not tested.  Other arch/x86/lib/*.S are 
> not used by um currently.  [Should analogous changes be made anyway?]
> 
> Comments?

thanks, i have picked up the x86 bits.

Will pick up later cleanup versions as well if there's some better macro 
approach to do this as an ENTRY thing, as we could consolidate both the 
start and the end into a single macro:

        .type __down_failed_trylock, @function
ENTRY(__down_failed_trylock)
        CFI_STARTPROC

        CFI_ENDPROC
        END(__down_failed_trylock)
        .size __down_failed_trylock, . - __down_failed_trylock

perhaps START_FUNCTION() and END_FUNCTION() macros?

	Ingo
