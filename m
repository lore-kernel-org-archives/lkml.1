Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0BQUjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:39:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:49119 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab0BQUjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:39:22 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1266420475.16707.31.camel@e102109-lin.cambridge.arm.com>
References: <20100208065519.GE1290@ucw.cz>
	 <1265628483.4020.63.camel@pc1117.cambridge.arm.com>
	 <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
	 <201002160922.47072.oliver@neukum.org> <1266397543.16346.264.camel@pasglop>
	 <1266420475.16707.31.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 07:37:00 +1100
Message-ID: <1266439020.16346.285.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 15:27 +0000, Catalin Marinas wrote:
> We do the same on ARM. The problem with most (all) HCD drivers that do
> PIO is that they copy the data to the transfer buffer but there is no
> call in this driver to flush_dcache_page(). The upper mass storage or
> filesystem layers don't call this function either, so there isn't
> anything that would set the PG_arch1 bit. 

Actually, clear it :-)

I suppose that's one thing that needs to be fixed in the drivers.

Cheers,
Ben.


