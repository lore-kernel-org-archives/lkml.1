Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYDXWlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYDXWlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYDXWln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:41:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:19728 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbYDXWlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XypyZN9Q+XP7LJKbsicQlltUXJh2go4e1FfEM/xZta+m6wgV6F8JC/7qXTQ/6JcLN/ij0ZuyHAHix7/MJ0A/xvJVeMr5thwPDkn51jigC7Uw6rFKdw+M9SNJPmcAU639vN8jUtaF6a8iWjOVeJTSR+DuLOyjGARrPYTNdXdA2C0=
Subject: Re: [git pull] generic bitops
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>
In-Reply-To: <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org>
References: <20080424215739.GA32378@elte.hu>
	 <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 15:41:37 -0700
Message-Id: <1209076897.20088.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 15:14 -0700, Linus Torvalds wrote:
> 
> On Thu, 24 Apr 2008, Ingo Molnar wrote:
> >
> > this started out as improvements/generalizations to x86 bitops, but grew 
> > generic impact (and generic optimizations) as well, so it's offered as a 
> > separate tree.
> 
> Can you do the config thing differently?
> 
> > diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
> > index e09edfa..49990ea 100644
> > --- a/arch/um/Kconfig.i386
> > +++ b/arch/um/Kconfig.i386
> > @@ -39,6 +39,14 @@ config ARCH_REUSE_HOST_VSYSCALL_AREA
> >  	bool
> >  	default y
> >  
> > +config GENERIC_FIND_FIRST_BIT
> > +	bool
> > +	default y
> > +
> > +config GENERIC_FIND_NEXT_BIT
> > +	bool
> > +	default y
> > +
> 
> .. because instead of having each architecture do these kinds of things, 
> we're trying to make the *generic* code (ie lib/Kconfig) do
> 
> 	config GENERIC_FIND_FIRST_BIT
> 		bool
> 		default n

config HAVE_GENERIC_FIND_FIRST_BIT
	def_bool n

(I know it defaults to n, but this pattern is becoming suggestive of
features that must be selected, in addition to the HAVE_ prefix)

Although I think for lib stuff, we may want to think about WANT_
prefixes to suggest you have to opt in.

Harvey

