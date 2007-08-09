Return-Path: <linux-kernel-owner+w=401wt.eu-S938992AbXHIHaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938992AbXHIHaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbXHIH3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:29:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:15637 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764889AbXHIH3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gmbF09AY4QM5l/qK496BBmUy4KRavv4RQetFF7PFr/Iydpop+EOFBdxEJ/TDgWZiqsMv53GVdHAz0ockhMCF7uZCN6psVSIRhNhXMafMqVhe0JDYiaHLleGlq8eGAb0ITPYIAQ24IREGVZj8D/GaLuVc4bXWLwY6AgpPtDO66q4=
Message-ID: <5d6222a80708090029o13577af4j4c99b46612b31ef7@mail.gmail.com>
Date: Thu, 9 Aug 2007 04:29:38 -0300
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
Looking at it more carefully, it turns out that those functions are
not eligible for being paravirt clients. They do no privileged
operation at all. In fact, all they do is bit manipulation.
That said, the code got a little bit cleaner by moving them down, and so I did.

But later on, you voiced concern about making CONFIG_PARAVIRT depend
on !VSMP. (and said it would be okay, because these functions would be
paravirt clients: but they won't) Given this updated picture, what's
your position about this?

Again, as they don't do anything besides bit manipulation, I don't
think they will stop VSMP from working with PARAVIRT.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
