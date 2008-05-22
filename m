Return-Path: <linux-kernel-owner+w=401wt.eu-S1766007AbYEVVif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766007AbYEVVif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761172AbYEVViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:38:10 -0400
Received: from www.tglx.de ([62.245.132.106]:41503 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760594AbYEVViJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:38:09 -0400
Date: Thu, 22 May 2008 23:37:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merging nmi 32/64 to nmi.c v2
In-Reply-To: <20080521192129.GE6932@cvg>
Message-ID: <alpine.LFD.1.10.0805222320160.3295@apollo.tec.linutronix.de>
References: <20080521163051.GB6932@cvg> <483467E1.6090808@ct.jp.nec.com> <20080521192129.GE6932@cvg>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Cyrill Gorcunov wrote:
> 
> Here is updated version (thanks Hiroshi) - I've moved these funcs
> to traps_64.c and it's compiled just fine (so we are going closer
> to merge someday even traps-32/64 ;)

Cyrill,

I really like that patch, but I'm a bit wary about the doit in one go
approach. Its pretty hard to review that way and in case of breakage
bisecting will just point to one large diff which is hard to decode.

Can you please try to make this a more fine grained patch series ?

Gradually add/modify the two files so they are identical at the
end. There are a couple of obvious steps, e.g. the move of function to
traps_*.c and adding the inline functions like get_timer_irqs().

Thanks,
	tglx
