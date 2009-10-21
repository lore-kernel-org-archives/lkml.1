Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZJUVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZJUVyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbZJUVyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:54:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbZJUVyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:54:22 -0400
Date: Wed, 21 Oct 2009 23:53:21 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>
Subject: Re: [PATCH] macintosh: Explicitly set llseek to no_llseek in
 ans-lcd
In-Reply-To: <20091021214537.GD4880@nowhere>
Message-ID: <alpine.LFD.2.00.0910212350210.3526@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153349.966159859@linutronix.de> <alpine.LFD.2.00.0910212305090.3526@localhost.localdomain> <20091021212137.GB4880@nowhere> <alpine.LFD.2.00.0910212327160.3526@localhost.localdomain>
 <20091021214537.GD4880@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Oct 2009, Frederic Weisbecker wrote:

> On Wed, Oct 21, 2009 at 11:33:17PM +0200, John Kacur wrote:
> > > Should we better pushdown default_llseek to every to every
> > > file operations that don't implement llseek?
> > > I don't know how many of them don't implement llseek() though.
> > > 
> > > That said we can't continue anymore with this default attribution
> > > of default_llseek() on new fops.
> > > 
> > 
> > If you don't explicitly set it to no_llseek, you automatically get the
> > default_llseek, which uses the BKL. So if your driver doesn't need it, it 
> > is best to explicitly set it to no_llseek.
> 
> 
> Sure, that's the right thing to do.
> 
>  
> > There is also a generic_file_llseek_unlocked, somewhat analogous to the 
> > unlocked_ioctls that you can use if you don't need to provide a full 
> > llseek yourself.
> 
> 
> No problem with that. Setting no_llseek or generic_file_llseek_unlocked,
> depending on the context is the right thing to do.
> 
> What I'm wondering about concerns the future code that will have
> no llsek() implemented in their fops.
> 
> We can't continue to use default_llseek() for future code unless we
> want to continue these post reviews and fixes forever.
> 

I'm thinking that the simplier approach, would be to make the 
default_llseek the unlocked one. Then you only have to audit the drivers 
that have the BKL - ie the ones we are auditing anyway, and explicitly set 
them to the bkl locked llseek.

There might be a hidden interaction though between the non-unlocked 
variety of ioctls and default llseek though.
