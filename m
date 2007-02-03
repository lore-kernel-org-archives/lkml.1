Return-Path: <linux-kernel-owner+w=401wt.eu-S1946427AbXBCJtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946427AbXBCJtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 04:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946426AbXBCJtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 04:49:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:38934 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946425AbXBCJtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 04:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XPgnbvO4b+XkcRezoIz4kkA7AoaRUTkI61k46lF6kgFCQmTaSngs8jMPyn4kvewsNeDfq2aTW8D7EwgEasMOhwbfxqfWnNb2IIsk4djg1VHjdLrCTKGvZA+g6/10b+D8TwQxt444/KT/Q5yrnU9NBbMS4Vn5rNM5XBrfTlOFFOs=
Subject: Re: 2.6.20-rc7: known regressions
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
In-Reply-To: <200702031033.42940.ak@suse.de>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	 <1170494391.31373.25.camel@funkylaptop>
	 <20070203012426.120ec586.akpm@linux-foundation.org>
	 <200702031033.42940.ak@suse.de>
Content-Type: text/plain; charset=utf-8
Date: Sat, 03 Feb 2007 10:49:35 +0100
Message-Id: <1170496175.31373.31.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 03 février 2007 à 10:33 +0100, Andi Kleen a écrit :
> >  /*
> > + * Wrap all the virtual calls in a way that forces the parameters on the stack.
> > + */
> > +
> > +#define efi_call_virt(f, args...) \
> > +     ((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
> > +
> > +static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
> > +{
> > +	return efi_call_virt(get_time, tm, tc);
> 
> Wouldn't it be better to just declare the pointers in efi.systab with 
> the correct attribute?  Then you wouldn't need all that ugly casting.

Was what I did in the initial patch: 
     http://lkml.org/lkml/2007/1/30/258 

The issue is that the structure definition is used on multiple
architectures (for now ia64 and i386) which might used different calling
conventions. As Bjorn Helgaas pointed out, ia64 already has such wrapper
functions. I agree that the casting isn't the nicest thing, but I prefer
that to writing asm stubs.

Fred

