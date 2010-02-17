Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab0BQU1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:27:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38508 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab0BQU1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:27:18 -0500
Date: Wed, 17 Feb 2010 20:26:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Oliver Neukum <oliver@neukum.org>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       "Gadiyar, Anand" <gadiyar@ti.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100217202617.GB30033@n2100.arm.linux.org.uk>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF84D1@dbde02.ent.ti.com> <Pine.LNX.4.44L0.1002171201190.1913-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002171201190.1913-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 12:02:21PM -0500, Alan Stern wrote:
> Why do you skip mapping the setup packet but not the data packet?

This is something of a FAQ in this thread.  Here are the responses to
similar questions yesterday:

"Gadiyar, Anand" <gadiyar@ti.com> said:
> Not really. For instance, in the case of the DMA engine in the MUSB
> controller in OMAP3, we can only use DMA with endpoints other than
> EP0, and EP0 is what is used for control transfers.
>
> It's not PIO for all the endpoints or DMA for all of them.

"Shilimkar, Santosh" <santosh.shilimkar@ti.com> said:
> On the OMAP4 (ARM cortex-a9) platform, the enumeration fails because control
> transfer buffers are corrupted. On our platform, we use PIO mode for control
> transfers and DMA for bulk transfers.
>
> The current stack performs dma cache maintenance even for the PIO transfers
> which leads to the corruption issue. The control buffers are handled by CPU
> and they already coherent from CPU point of view.

