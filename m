Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbYFKOqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbYFKOqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbYFKOqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:46:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461AbYFKOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:46:43 -0400
Date: Wed, 11 Jun 2008 07:46:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Paul Mackerras <paulus@samba.org>, Matthew Wilcox <matthew@wil.cx>,
       Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <200806111500.30789.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.10.0806110736500.3101@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop> <200806101656.51211.nickpiggin@yahoo.com.au> <18511.21025.978328.596571@cargo.ozlabs.ibm.com> <200806111500.30789.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jun 2008, Nick Piggin wrote:
> 
> I can't actually find the definitive statement in the Intel manuals
> saying UC is strongly ordered also WRT WB. Linus?

Definitive? Dunno. But look in the Architecture manual, volume 3A, 10.3 
"Methods of Caching Available", and then under the bullet about Write 
Combining (WC), it says

  the writes may be delayed until the next occurrence of a serializing 
  event; such as, an SFENCE of MFENCE instruction, CPUID execution, a read 
  or write to uncached memory, an interrupt occurrence, or a LOCK 
  instruction execution.

However, it's worth noting that

 - documentation can be wrong, or even if right, can be Intel-specific.

 - the above is expressly _only_ about the WC buffer, not about regular 
   memory writes. Cached memory accesses are different from WC accesses.

so in the end, the thing that matters is how things actually work.

		Linus
