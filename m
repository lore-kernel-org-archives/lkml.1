Return-Path: <linux-kernel-owner+w=401wt.eu-S933565AbZDASzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbZDASzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759443AbZDASzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:55:33 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53349 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221AbZDASzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C2XfYmaySwX7vncl3LK+6cpGefXF+UbFIrbtum5GR4KOMTreS56rjJMIOuDh0kM/gg
         O6/ryKZi6QOxGXZU+YElOAsQKot2aZlqnyaiOvhxDMx2m72a8dZ56VA7YmOlKwQHwe5n
         wCRL6DPlltH/gELTD4sQZmr4ldAZZyeTXutJs=
Date: Wed, 1 Apr 2009 22:56:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, xemul@openvz.org, yhlu.kernel@gmail.com
Subject: Re: [patch 4/6] x86: irqinit - merge native_init_IRQ
Message-ID: <20090401185634.GB28212@localhost>
References: <20090329201545.470255691@openvz.org> <20090329202208.155551990@openvz.org> <20090401145328.GB6196@elte.hu> <20090401161609.GD15781@localhost> <20090401162250.GA22517@elte.hu> <20090401164001.GE15781@localhost> <20090401172208.GG15781@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401172208.GG15781@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Wed, Apr 01, 2009 at 09:22:08PM +0400]
| Ingo,
| 
| here is what I meant. The x86_quirk_pre_intr_init
| and x86_quirk_intr_init do all we need. The only
| paid off -- is that on x86-64 the functions
| will check for x86_quirks->arch_intr_init and
| x86_quirks->arch_pre_intr_init which are always
| NULL for x86-64 (at least for now). If that is
| acceptable -- then apply the patch below for
| testing please. Othrewise we could eliminate
| useless check by #ifdef (which would not be
| that much differ from what I've posted initially
| in patch series :)
| 
|         Cyrill
| ---
| 
| x86: irqinit - merge native_init_IRQ
| 
| For this purpose on X86-64 init_ISA_irqs is called
| indirectly via x86_quirk_pre_intr_init (ie the same
| way as X86-32 do).
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| ---
|  arch/x86/kernel/irqinit_32.c |    4 +++-
|  arch/x86/kernel/irqinit_64.c |   22 +++++++++++++++++++++-
|  arch/x86/kernel/setup.c      |    2 +-
|  3 files changed, 25 insertions(+), 3 deletions(-)
| 
...

Ingo,

here are the reasons I found to vote for _this_ implementation
(ie using x86_quirk_intr_init and x86_quirk_pre_intr_init
 for both x86-32 and x86-64 platforms instead of direct function
 pointers)

1) Both are called on x86-32 as a former.
2) For x86-32 among the init_ISA_irqs call
   the quirk itself is needed (VISWS code)

        Cyrill
