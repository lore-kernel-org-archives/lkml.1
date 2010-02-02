Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0BBMH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:07:59 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:57839 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab0BBMH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:07:58 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: USB mass storage and ARM cache coherency
Date: Tue, 2 Feb 2010 13:07:56 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
References: <20100129185434.GH19501@one-eyed-alien.net> <201002021248.10994.oliver@neukum.org> <1265112072.12634.53.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1265112072.12634.53.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002021307.56991.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 2. Februar 2010 13:01:12 schrieb Catalin Marinas:
> On Tue, 2010-02-02 at 11:48 +0000, Oliver Neukum wrote:
> > Am Montag, 1. Februar 2010 18:29:14 schrieb Catalin Marinas:
> > > +       if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) == PIPE_BULK) {
> > > +               void *ptr;
> > > +               for (ptr = urb->transfer_buffer;
> > > +                    ptr < urb->transfer_buffer + urb->transfer_buffer_length;
> > > +                    ptr += PAGE_SIZE)
> > > +                       flush_dcache_page(virt_to_page(ptr));
> > 
> > Is it correct to limit this to BULK pipes?
> 
> I'm not entirely sure. The flush_dcache_page() should only be called for
> pages that may be mapped into user space (page cache pages). We don't
> need this for control buffers. It was my impression that what's coming
> from the mass storage layer intended for page cache pages has the
> PIPE_BULK type (I may be wrong though).

For storage that is correct. But what about other sources of pages,
for example iSCSI?

	Regards
		Oliver
