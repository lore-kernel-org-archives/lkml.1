Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419Ab0BZQwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:52:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54646 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965383Ab0BZQwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:52:07 -0500
Date: Fri, 26 Feb 2010 11:52:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       <linux-usb@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: USB mass storage and ARM cache coherency
In-Reply-To: <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
Message-ID: <Pine.LNX.4.44L0.1002261150370.2029-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Catalin Marinas wrote:

> For mmap'ed pages (and present in the page cache), is it guaranteed that
> the HCD driver won't write to it once it has been mapped into user
> space? If that's the case, it may solve the problem by just reversing
> the meaning of PG_arch_1 on ARM and assume that a newly allocated page
> has dirty D-cache by default.

Nothing is guaranteed.  The HCD will write to wherever it is asked.  If 
a driver does input to an mmap'ed page, the HCD won't even know that 
the page is mmap'ed.

Alan Stern

