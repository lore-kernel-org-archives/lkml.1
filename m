Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0BBLF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:05:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64599 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185Ab0BBLF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:05:56 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
In-Reply-To: <20100202063904.GK13428@linux-sh.org>
References: <20100202063904.GK13428@linux-sh.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 02 Feb 2010 11:05:39 +0000
Message-Id: <1265108739.12634.38.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 11:05:40.0235 (UTC) FILETIME=[A7E235B0:01CAA3F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 06:39 +0000, Paul Mundt wrote:
> On Mon, Feb 01, 2010 at 05:29:14PM +0000, Catalin Marinas wrote:
> > diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
> > index 27b8f7c..4d3eeee 100644
> > --- a/drivers/usb/host/isp1760-hcd.c
> > +++ b/drivers/usb/host/isp1760-hcd.c
> > @@ -18,6 +18,8 @@
> >  #include <linux/uaccess.h>
> >  #include <linux/io.h>
> >  #include <asm/unaligned.h>
> > +#include <asm/cacheflush.h>
> > +#include <asm/memory.h>
> 
> asm/memory.h isn't a portable header. If you are including it for
> virt_to_page(), linux/io.h should already bring that in via asm/io.h.
> If arm doesn't bring in virt_to_page() through its asm/io.h, then fix the
> headers there please.

In the ARM case, yes, it brings virt_to_page() but I'm not sure that's
the case for the other architectures. I think a better header is
linux/mm.h which already uses this function in virt_to_head_page().

-- 
Catalin

