Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbXAXRAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbXAXRAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXAXRAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:00:00 -0500
Received: from frankvm.xs4all.nl ([80.126.170.174]:51220 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752031AbXAXQ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:59:59 -0500
Date: Wed, 24 Jan 2007 17:59:58 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Yakov Lerner <iler.ml@gmail.com>
Cc: Kernel Linux <linux-kernel@vger.kernel.org>
Subject: Re: usb2 external disk not recognized if connected during boot, but recognized if not connected during boot
Message-ID: <20070124165958.GA8143@janus>
References: <f36b08ee0701230113m2f244a4et5cf866cf1b38f4d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f36b08ee0701230113m2f244a4et5cf866cf1b38f4d4@mail.gmail.com>
User-Agent: Mutt/1.4.1i
X-BotBait: val@frankvm.com, kuil@frankvm.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 11:13:03AM +0200, Yakov Lerner wrote:
> On a small Celeron-based appliance, Usb2 disk is not recognized *if*
> it is connected during kernel boot.
> But if not connected during boot, and I connect it later, it is
> recognized and works ok.
> I tried various 2.6.16, 17 and 18 kernels, both modular, and
> all-static, with the same result.
> What can this be.
> This is ehci controller. Can it be problematic Irq assignments on the
> motherboard ?
> Btw, during boot, access lights go on forever on the Usb drive. Couple
> of kernels are stuck
> at this point. Most kernels go through, but disk is still not
> recognized. If I disconnect and re-connect usb drive later, then it is
> never recognized (if it was connected earlier during boot). Again, if
> the disk was not connected during boot, all kernels recognize it and
> work with it.

Try making EHCI a module and modprobe it after booting the kernel. I
have a mainboard/USB stick combo which refuses to work when plugged in
during cold boot with EHCI driver in kernel. The driver repeatedly tried
to reset USB hardware and then gave up. Replugging did work however.

I worked around the issue by booting without EHCI driver in kernel. A more
modern USB stick fixed it too. After some investigation consensus was that
the hardware combination was broken and the EHCI driver was not at fault.

Maybe this is a similar hardware problem. Does the USB disk has its
own power? then replugging USB may not be enough and you might also
need to toggle USB disk power in order to make it work again.

-- 
Frank
