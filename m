Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0BXHQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:16:27 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:46949 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab0BXHQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:16:25 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: USB mass storage and ARM cache coherency
Date: Wed, 24 Feb 2010 08:16:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Greg KH <greg@kroah.com>, "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Ming Lei <tom.leiming@gmail.com>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>
References: <1266445892.16346.306.camel@pasglop> <201002192153.22159.oliver@neukum.org> <1266979689.23523.1669.camel@pasglop>
In-Reply-To: <1266979689.23523.1669.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002240816.10178.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. Februar 2010 03:48:09 schrieb Benjamin Herrenschmidt:
> On Fri, 2010-02-19 at 21:53 +0100, Oliver Neukum wrote:
> > Am Freitag, 19. Februar 2010 18:36:51 schrieb Catalin Marinas:
> > > If a page is already mapped in user space, flush_dcache_page() on ARM
> > > does the flushing rather than deferring it to update_mmu_cache(). The
> > > PIO HCD drivers, however, don't call flush_dcache_page(). Is it possible
> > > that the HCD could transfer data into a page cache page already mapped
> > > in user space? My understanding is that the scenario above is possible.
> > 
> > Yes, video drivers do that. 
> 
> In which case it would be up to the video driver to call
> flush_dcache_page() (though if it's v4l you are talking about, maybe it
> might make sense to push it into the v4l layer itself).

I don't know. The issue seems quite complex. It would seem better to
centralize it as far as practical. Do you have a wrapper drivers could
call?

	Regards
		Oliver
