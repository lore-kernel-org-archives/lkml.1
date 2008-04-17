Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbYDQJEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbYDQJEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbYDQJEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:04:39 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39709 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297AbYDQJEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:04:38 -0400
Message-Id: <1208423077.31914.1248369455@webmail.messagingengine.com>
X-Sasl-Enc: h0o+qik3Qh5WpG4422TzT5lIbxi9bw2x7XC5UxVGBTk+ 1208423077
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Paul Mackerras" <paulus@samba.org>, "Ingo Molnar" <mingo@elte.hu>,
       linuxppc-dev@ozlabs.org
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1208191719.12568.1247788911@webmail.messagingengine.com>   
   <20080416125724.GC6304@elte.hu>   
   <20080416135508.GA16439@mailshack.com>   
   <20080416144051.GH24383@elte.hu>   
   <18438.33744.389334.543623@cargo.ozlabs.ibm.com>
Subject: Re: [PATCH] x86: fix find_next_bit breakage on ppc and powerpc
In-Reply-To: <18438.33744.389334.543623@cargo.ozlabs.ibm.com>
Date: Thu, 17 Apr 2008 11:04:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 08:55:12 +1000, "Paul Mackerras" <paulus@samba.org>
said:
> Ingo Molnar writes:
> > 
> > * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> > 
> > > Powerpc (and ppc) have their have some code in their bitops.h which 
> > > used to be exacly the same as asm-generic/bitops/find.h. Include this 
> > > header instead.
> > > 
> > > This should also fix the compile problems due to the generic 
> > > find_next_bit changes. Those were fixed by Thomas Gleixner in 
> > > asm-generic/bitops/find.h earlier.
> > > 
> > > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > 
> > thanks, applied. I dropped:
> 
> Why are powerpc (and ppc) patches
> - not being sent to the powerpc maintainer (me)
> - not being cc'd to the linuxppc-dev@ozlabs.org list
> - ending up going through the x86 tree?

Hello,

My apologies for that. The patches that are now in x86#testing were
needed because of changes I introduced. Thomas Gleixner found a
problem with the patches that caused compile problems for basically
all archs with GENERIC_FIND_NEXT_BIT=y, and his fix was to change
asm-generic/bitops/find.h. However, ppc and powerpc did things
differently... (x86 too, but they have special permissions ;) )

(Better late than never) Please consider applying the patch in
        http://lkml.org/lkml/2008/4/16/107
as:

[PATCH] powerpc: use asm-generic/bitops/find.h in bitops.h

Powerpc (and ppc) have some code in their bitops.h that is
exacly the same as asm-generic/bitops/find.h. Include this
header instead of the private implementation.

> How come patches to unify x86_32 and x86_64 bitops need to end up
> touching powerpc?

This was not a pure unification. Originally I wanted to convert
both x86_64 and i386 to the existing generic bitops. Andi Kleen,
however, objected because x86_64 would than lose a certain
optimization for small bitmaps. I moved this optimization to
the generic code, and broke non-x86. Everyone except ppc/powerpc
was fixed by Thomas Gleixner (in a generic header file).
http://lkml.org/lkml/2008/4/16/107 just changes ppc/powerpc in
such a way that Thomas' fix works there too.

Greetings,
    Alexander

> Paul.
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - The professional email service

