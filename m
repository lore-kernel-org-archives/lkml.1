Return-Path: <linux-kernel-owner+w=401wt.eu-S1764619AbXHXVOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764619AbXHXVOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbXHXVOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:14:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34281 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350AbXHXVOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:14:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Re: [RFC][PATCH -mm 3/4] Hibernation: Pass CR3 in the image header on x86_64
Date: Fri, 24 Aug 2007 23:24:19 +0200
User-Agent: KMail/1.9.5
Cc: linux-pm@lists.linux-foundation.org, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
References: <200708221015.16493.rjw@sisk.pl> <200708222249.51616.rjw@sisk.pl> <20070824090220.GA2412@elf.ucw.cz>
In-Reply-To: <20070824090220.GA2412@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708242324.19866.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 24 August 2007 11:02, Pavel Machek wrote:
> Hi!
> 
> > > > No, I do not think I like that. I believe both -> control and -> crc
> > > > is just useless paranoia. Bitflip in this area is not going to be any
> > > > worse than bitflip anywhere else, we should not pretend this is
> > > > somehow "more important".
> > > > 
> > > > -> control should really be "protocol version"... probably should
> > > > contain some field that is easy to increment.
> > > 
> > > OK
> > > 
> > > Perhaps I'll just remove the crc field.
> > 
> > Like in the patch below.
> 
> Yep, thanks.
> 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Since we already pass the address of restore_registers() in the image header,
> > we can also pass the value of the CR3 register from before the hibernation in
> > the same way.  This will allow us to avoid using init_level4_pgt page tables
> > during the restore.
> 
> ACK.
> 
> > @@ -9,6 +9,7 @@
> >  
> >  #include <linux/smp.h>
> >  #include <linux/suspend.h>
> > +#include <linux/crc32.h>
> >  #include <asm/proto.h>
> >  #include <asm/page.h>
> >  #include <asm/pgtable.h>
> 
> This one is no longer neccessary.

I forgot about it.

I've already sent the 1/4 and 2/4 patches to Andrew, so I'll keep the remaining
two ones in the queue for a couple of days.

Thanks for the ACKs!

Greetings,
Rafael
