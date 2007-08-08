Return-Path: <linux-kernel-owner+w=401wt.eu-S934740AbXHHOKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740AbXHHOKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934474AbXHHOKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:10:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:50473 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934393AbXHHOKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lLs6xsocaLll/BCYx8efmW6Kae+sbJ3CkOGJzo3lcMyXyfn8zIQeWL4swQ6xUVb6J9wGA37yVGxFU64y8X/5lW/ecaAR2DXwOjqOxtP23FMvvPP+es51fcKf1hxaEQlMNkZEZXYL1u+MhqcPInHWYEecuBIbqrSH9vdxyHEETxI=
Message-ID: <5d6222a80708080710n296f6da8i1dc08d914baeb27a@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:10:28 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 3/25] [PATCH] irq_flags / halt routines
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <200708081114.21260.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <1186546763582-git-send-email-gcosta@redhat.com>
	 <11865467662182-git-send-email-gcosta@redhat.com>
	 <200708081114.21260.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andi Kleen <ak@suse.de> wrote:
>
> > +#ifdef CONFIG_PARAVIRT
> > +#include <asm/paravirt.h>
> > +#  ifdef CONFIG_X86_VSMP
> > +static inline int raw_irqs_disabled_flags(unsigned long flags)
> > +{
> > +     return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
> > +}
> > +#  else
> > +static inline int raw_irqs_disabled_flags(unsigned long flags)
> > +{
> > +     return !(flags & X86_EFLAGS_IF);
> > +}
> > +#  endif
>
> You should really turn the vsmp special case into a paravirt client first
> instead of complicating all this even more.

By "client" you mean a user of the paravirt interface?

> > +#ifndef CONFIG_PARAVIRT
> > +#define raw_safe_halt        native_raw_safe_halt
> > +#define halt         native_halt
> > +#endif /* ! CONFIG_PARAVIRT */
>
> This seems inconsistent
Sorry andi. Can't see why. Could you elaborate?


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
