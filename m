Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab0BBMBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:01:25 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36085 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910Ab0BBMBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:01:23 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
In-Reply-To: <201002021248.10994.oliver@neukum.org>
References: <20100129185434.GH19501@one-eyed-alien.net>
	 <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
	 <201002021248.10994.oliver@neukum.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 02 Feb 2010 12:01:12 +0000
Message-Id: <1265112072.12634.53.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 12:01:13.0755 (UTC) FILETIME=[6AD0FEB0:01CAA3FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 11:48 +0000, Oliver Neukum wrote:
> Am Montag, 1. Februar 2010 18:29:14 schrieb Catalin Marinas:
> > +       if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) == PIPE_BULK) {
> > +               void *ptr;
> > +               for (ptr = urb->transfer_buffer;
> > +                    ptr < urb->transfer_buffer + urb->transfer_buffer_length;
> > +                    ptr += PAGE_SIZE)
> > +                       flush_dcache_page(virt_to_page(ptr));
> 
> Is it correct to limit this to BULK pipes?

I'm not entirely sure. The flush_dcache_page() should only be called for
pages that may be mapped into user space (page cache pages). We don't
need this for control buffers. It was my impression that what's coming
from the mass storage layer intended for page cache pages has the
PIPE_BULK type (I may be wrong though).

-- 
Catalin

