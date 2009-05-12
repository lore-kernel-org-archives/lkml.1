Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbZELAZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbZELAZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZELAZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:25:31 -0400
Received: from gw.goop.org ([64.81.55.164]:43946 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbZELAZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:25:31 -0400
Message-ID: <4A08C1F9.1020308@goop.org>
Date: Mon, 11 May 2009 17:25:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [GIT PULL] x86: paravirt_ops updates
References: <1241728373-3537-1-git-send-email-jeremy@goop.org>
In-Reply-To: <1241728373-3537-1-git-send-email-jeremy@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Hi Ingo,
>
> This series has a some changes to x86 paravirt_ops:
>   

Ping?  Did you overlook these changes, or have you just not had a chance 
to look at them?

Thanks,
    J

> x86/paravirt: split paravirt definitions into paravirt_types.h
>
>   Move all the type-like definitions into asm/paravirt_types.h
>
> x86: split out core __math_state_restore
>
>   Split out the core of math_state_restore() into __math_state_restore(),
>   which just does what's needed for a context switch (ie, assumes
>   TS is already clear, and that the fpu context exists).
>
> x86-32: make sure clts is batched during context switch
> x86-64: move unlazy_fpu() into lazy cpu state part of context switch
> x86-64: move clts into batch cpu state updates when preloading fpu
>
>   Make sure the TS state updates during context switch are performed in
>   the lazy CPU update region so that they can be batched when running
>   paravirtualized.
>
> The following changes since commit 9ce5424d75e56891905b77d1589924765e62059a:
>   Ingo Molnar (1):
>         Merge branch 'x86/urgent'
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/paravirt
>
> Jeremy Fitzhardinge (5):
>       x86/paravirt: split paravirt definitions into paravirt_types.h
>       x86: split out core __math_state_restore
>       x86-32: make sure clts is batched during context switch
>       x86-64: move unlazy_fpu() into lazy cpu state part of context switch
>       x86-64: move clts into batch cpu state updates when preloading fpu
>
>  arch/x86/include/asm/i387.h           |    1 +
>  arch/x86/include/asm/paravirt.h       |  711 +--------------------------------
>  arch/x86/include/asm/paravirt_types.h |  720 +++++++++++++++++++++++++++++++++
>  arch/x86/kernel/process_32.c          |   27 +-
>  arch/x86/kernel/process_64.c          |   34 +-
>  arch/x86/kernel/traps.c               |   33 +-
>  6 files changed, 783 insertions(+), 743 deletions(-)
>  create mode 100644 arch/x86/include/asm/paravirt_types.h
>
> Thanks,
> 	J
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>   

