Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966330Ab0BZVx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:53:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:58371 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966217Ab0BZVx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:53:57 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Greg KH <greg@kroah.com>, "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Ming Lei <tom.leiming@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.1002261150370.2029-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1002261150370.2029-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 08:51:22 +1100
Message-ID: <1267221082.23523.1822.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 11:52 -0500, Alan Stern wrote:
> > For mmap'ed pages (and present in the page cache), is it guaranteed that
> > the HCD driver won't write to it once it has been mapped into user
> > space? If that's the case, it may solve the problem by just reversing
> > the meaning of PG_arch_1 on ARM and assume that a newly allocated page
> > has dirty D-cache by default.
> 
> Nothing is guaranteed.  The HCD will write to wherever it is asked.  If 
> a driver does input to an mmap'ed page, the HCD won't even know that 
> the page is mmap'ed.

Right but that won't happen unless somebody explicitely caused that
input to happen, typically, a userspace read(). I$/D$ coherency isn't
implicit in that case.

The question is more when the kernel itself moves a page in/out from
underneath the application (mmap'ed executable pages). One it's mapped
in, it won't be written to by the HCD unless something explicitely does
something to cause that write. If it's swapped out and back in, it will
have been unmapped. 

Cheers,
Ben.

