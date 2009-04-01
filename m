Return-Path: <linux-kernel-owner+w=401wt.eu-S932248AbZDAPA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbZDAPA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761423AbZDAPAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:00:06 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:56398 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbZDAPAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GSAXWuD6bPbpiITBXW6X344NZ5hZ9f0fB1BVUGyTJHAfuM/QQ9saiaQVaJ9MakEri3
         uV1LqLYXy8F8nUsBzmPAc/SQPOo9fbi17YnErCswt23+WdJrt/afv9iMR8RJZT4WqTkk
         YMukoLMeV3JmYH9IbEJrteH58J5Ji56GKV5+A=
Date: Wed, 1 Apr 2009 19:01:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       xemul@openvz.org, yhlu.kernel@gmail.com
Subject: Re: [patch 4/6] x86: irqinit - merge native_init_IRQ
Message-ID: <20090401150102.GC8186@localhost>
References: <20090329201545.470255691@openvz.org> <20090329202208.155551990@openvz.org> <20090401145328.GB6196@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401145328.GB6196@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Apr 01, 2009 at 04:53:28PM +0200]
...
| 
| > Index: linux-2.6.git/arch/x86/kernel/setup.c
| > ===================================================================
| > --- linux-2.6.git.orig/arch/x86/kernel/setup.c
| > +++ linux-2.6.git/arch/x86/kernel/setup.c
| > @@ -1087,3 +1087,11 @@ void __init x86_quirk_time_init(void)
| >  	setup_irq(0, &irq0);
| >  }
| >  #endif /* CONFIG_X86_32 */
| > +
| > +#ifdef CONFIG_X86_64
| > +void x86_quirk_pre_intr_init(void)
| > +{
| > +	init_ISA_irqs();
| > +}
| > +void x86_quirk_intr_init(void) { }
| > +#endif
| 
| Hm, wouldnt it be cleaner to add it as a new quirk function vector 
| in struct x86_quirks? See arch/x86/include/asm/setup.h.
| 
| 	Ingo
| 

Will take a look, thanks!

        Cyrill
