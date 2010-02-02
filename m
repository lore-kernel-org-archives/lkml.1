Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0BBPya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:54:30 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57835 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835Ab0BBPy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:54:29 -0500
Subject: Re: [PATCH] isp1760: Flush the D-cache for the pipe-in transfer
	buffers
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sebastian Siewior <bigeasy@linutronix.de>
In-Reply-To: <d82e647a1002020741n4a048395o6ebf7ffaf8457819@mail.gmail.com>
References: <d82e647a1002020741n4a048395o6ebf7ffaf8457819@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 02 Feb 2010 15:54:18 +0000
Message-Id: <1265126058.12634.94.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 15:54:19.0358 (UTC) FILETIME=[FAE2A7E0:01CAA41F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 15:41 +0000, Ming Lei wrote:
> 2010/2/2 Catalin Marinas <catalin.marinas@arm.com>:
> 
> > +       if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) == PIPE_BULK) {
> > +               void *ptr;
> > +               for (ptr = urb->transfer_buffer;
> > +                    ptr < urb->transfer_buffer + urb->transfer_buffer_length;
> > +                    ptr += PAGE_SIZE)
> > +                       flush_dcache_page(virt_to_page(ptr));
> 
> If the page is mapped into highmem, seems virt_to_page doesn't work well.

You are right but is it possible that we get a highmem virtual address
in this case?

As for a general solution, maybe trying to define something like a pio_*
API would work better.

-- 
Catalin

