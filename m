Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0BQJPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:15:54 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:51484 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab0BQJPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:15:52 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: USB mass storage and ARM cache coherency
Date: Wed, 17 Feb 2010 10:15:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>
References: <20100208065519.GE1290@ucw.cz> <201002160922.47072.oliver@neukum.org> <1266397543.16346.264.camel@pasglop>
In-Reply-To: <1266397543.16346.264.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002171015.52875.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 17. Februar 2010 10:05:43 schrieb Benjamin Herrenschmidt:
> > Would you care to elaborate on the exact nature of the bug you are
> > fixing?
> 
> I missed part of this thread, so forgive me if I'm a bit off here, but
> if the problem is indeed I$/D$ cache coherency vs. PIO transfers, then
> this is a long solved issue on other archs such as ppc (and I think
> sparc).

We should have changed the subject line.

There's a second problem. It turns out that on ARM
mapping for DMA must not be done if PIO will be used. Some HCDs
use PIO for some transfers but DMA for others. The generic layer
must learn about this.

	Regards
		Oliver
