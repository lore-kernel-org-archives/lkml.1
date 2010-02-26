Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934751Ab0BZA1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:27:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:39437 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934672Ab0BZA1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:27:11 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <201002250448.17866.oliver@neukum.org>
References: <1266445892.16346.306.camel@pasglop>
	 <201002240816.10178.oliver@neukum.org>
	 <1267045954.23523.1692.camel@pasglop>
	 <201002250448.17866.oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 11:22:50 +1100
Message-ID: <1267143770.23523.1763.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 04:48 +0100, Oliver Neukum wrote:
> Am Mittwoch, 24. Februar 2010 22:12:34 schrieb Benjamin Herrenschmidt:
> > On Wed, 2010-02-24 at 08:16 +0100, Oliver Neukum wrote:
> > > I don't know. The issue seems quite complex. It would seem better to
> > > centralize it as far as practical. Do you have a wrapper drivers could
> > > call?
> > 
> > flush_dcache_page() ? :-)
> 
> Will this do anything on arches that don't need it?

No, it's going to be an empty inline:

arch/x86/include/asm/cacheflush.h:static inline void flush_dcache_page(struct page *page) { }

> Secondly, can we have a wrapper that you can pass a pointer and an
> offset?

I'm sure you can make one :-) Use virt_to_page() though that will not
work for vmap/vmalloc space of course.
 
> > Now, the subsystem might be the one to know whether something is mapped
> > into userspace or not (v4l in our case) in which case a wrapper could be
> > created.
> 
> If possible, I'd like to centralize this. Drivers are likely to get this wrong.

Right. In the case of v4l, it's probably something that should go into
the subsystem. IE. That's how it works for block too, it's done at the
BIO and/or filesystem layer (though individual filesystems do have their
hand in the pudding). 

Cheers,
Ben.

> 	Regards
> 		Oliver
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


