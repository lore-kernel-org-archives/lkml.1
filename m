Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZJUVd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZJUVd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZJUVd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:33:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbZJUVd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:33:56 -0400
Date: Wed, 21 Oct 2009 23:33:17 +0200 (CEST)
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
In-Reply-To: <20091021212137.GB4880@nowhere>
Message-ID: <alpine.LFD.2.00.0910212327160.3526@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153349.966159859@linutronix.de> <alpine.LFD.2.00.0910212305090.3526@localhost.localdomain> <20091021212137.GB4880@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Oct 2009, Frederic Weisbecker wrote:

> On Wed, Oct 21, 2009 at 11:07:18PM +0200, John Kacur wrote:
> > From 0c2b412cdccf73bdeb19bb866bfe556942eaeca2 Mon Sep 17 00:00:00 2001
> > From: John Kacur <jkacur@redhat.com>
> > Date: Wed, 21 Oct 2009 23:01:12 +0200
> > Subject: [PATCH] macintosh: Explicitly set llseek to no_llseek in ans-lcd
> > 
> > Now that we've removed the BKL here, let's explicitly set lleek to no_llseek
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > ---
> >  drivers/macintosh/ans-lcd.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/macintosh/ans-lcd.c b/drivers/macintosh/ans-lcd.c
> > index 4ae8ec9..a1a1bde 100644
> > --- a/drivers/macintosh/ans-lcd.c
> > +++ b/drivers/macintosh/ans-lcd.c
> > @@ -137,6 +137,7 @@ const struct file_operations anslcd_fops = {
> >  	.write		= anslcd_write,
> >  	.unlocked_ioctl	= anslcd_ioctl,
> >  	.open		= anslcd_open,
> > +	.llseedk	= no_llseek,
> 
> 
> llseedk? :)
> 
> 
> Should we better pushdown default_llseek to every to every
> file operations that don't implement llseek?
> I don't know how many of them don't implement llseek() though.
> 
> That said we can't continue anymore with this default attribution
> of default_llseek() on new fops.
> 

If you don't explicitly set it to no_llseek, you automatically get the
default_llseek, which uses the BKL. So if your driver doesn't need it, it 
is best to explicitly set it to no_llseek.

There is also a generic_file_llseek_unlocked, somewhat analogous to the 
unlocked_ioctls that you can use if you don't need to provide a full 
llseek yourself.
