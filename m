Return-Path: <linux-kernel-owner+w=401wt.eu-S934600AbXHHOXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934600AbXHHOXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbXHHOXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:23:41 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:60110 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbXHHOXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=McsfK29zfwkvJRf5B9yeV2feoKFfZWgCtJGdhIS+dwVHT4f/n5l3ZLseu6gYnTcbgYJKzJF8YQKBt4XH0CMrtbryUF9tZcMnqUmJ3QXg+0F/JeLOfkhGll67H6J6n8GmXHejnBeO15WcI3bPxmhVSbbMhCZAQArSiOHw+AA5DDc=
Message-ID: <5d6222a80708080723h6efbf857yd707e85ccb713b6@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:23:37 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 3/25] [PATCH] irq_flags / halt routines
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <200708081614.52391.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <200708081114.21260.ak@suse.de>
	 <5d6222a80708080710n296f6da8i1dc08d914baeb27a@mail.gmail.com>
	 <200708081614.52391.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> On Wednesday 08 August 2007 16:10:28 Glauber de Oliveira Costa wrote:
> > On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> > >
> > > > +#ifdef CONFIG_PARAVIRT
> > > > +#include <asm/paravirt.h>
> > > > +#  ifdef CONFIG_X86_VSMP
> > > > +static inline int raw_irqs_disabled_flags(unsigned long flags)
> > > > +{
> > > > +     return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
> > > > +}
> > > > +#  else
> > > > +static inline int raw_irqs_disabled_flags(unsigned long flags)
> > > > +{
> > > > +     return !(flags & X86_EFLAGS_IF);
> > > > +}
> > > > +#  endif
> > >
> > > You should really turn the vsmp special case into a paravirt client first
> > > instead of complicating all this even more.
> >
> > By "client" you mean a user of the paravirt interface?
>
> Yes

Ohhh, I see. You're talking about just the first piece of code inside
the #ifdef CONFIG_PARAVIRT. In this case yes, I agree with you. It can
be done.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
