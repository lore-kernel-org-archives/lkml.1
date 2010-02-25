Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab0BZFgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:36:13 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47301 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587Ab0BZFgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:36:11 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Oliver Neukum <oliver@neukum.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Greg KH <greg@kroah.com>, "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Ming Lei <tom.leiming@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1267045954.23523.1692.camel@pasglop>
References: <1266445892.16346.306.camel@pasglop>
	 <201002192153.22159.oliver@neukum.org>
	 <1266979689.23523.1669.camel@pasglop>
	 <201002240816.10178.oliver@neukum.org>
	 <1267045954.23523.1692.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 12:36:25 +0000
Message-ID: <1267101385.2902.8.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 08:12 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2010-02-24 at 08:16 +0100, Oliver Neukum wrote:
> > I don't know. The issue seems quite complex. It would seem better to
> > centralize it as far as practical. Do you have a wrapper drivers could
> > call?
> 
> flush_dcache_page() ? :-)

Actually, that can be wrong depending on the implementation.  The
problem is incoherency of the kernel page (dirty) with respect to user
space aliases (clean).  What has to happen on parisc is that the kernel
alias needs flushing.  We can guarantee the userspace aliases to be
clean (and not moved in).  We wouldn't want to incur the expense of
flushing the user space pages as well.

> Now, the subsystem might be the one to know whether something is mapped
> into userspace or not (v4l in our case) in which case a wrapper could be
> created.

Right, so it's the responsibility of the API used by the subsystem.
Thus Caitlin's pio_kmap seems the right one ... I don't understand what
the additional problems are.

James


