Return-Path: <linux-kernel-owner+w=401wt.eu-S1763122AbZFNUfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763122AbZFNUfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZFNUe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:34:57 -0400
Received: from www.tglx.de ([62.245.132.106]:45041 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbZFNUe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:34:56 -0400
Date: Sun, 14 Jun 2009 22:34:45 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Wolfram Sang <w.sang@pengutronix.de>,
       devicetree-discuss@ozlabs.org, Magnus Damm <magnus.damm@gmail.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090614203444.GH3639@local>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de> <1244765062-14144-3-git-send-email-w.sang@pengutronix.de> <20090614122136.GD3639@local> <20090614171406.GA1010@pengutronix.de> <20090614183357.GE3639@local> <20090614190533.GA7387@pengutronix.de> <20090614192359.GG3639@local> <4A355155.4020500@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A355155.4020500@grandegger.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 09:36:53PM +0200, Wolfgang Grandegger wrote:
> >>>> 	if (uioinfo->irq == NO_IRQ)
> >>>> 		uioinfo->irq = UIO_IRQ_NONE;
> >>> Sorry for my ignorance, but what is NO_IRQ? If I do
> 
> It's 0 on PowerPC but ARM seems still to use -1.

Using 0 is simply wrong, especially if people do something like

if (!irq)
	return -ERROR;

IRQ number 0 _is_ a valid irq. Maybe not on all platforms, but in generic
code (like UIO) you have to assume it is.

> 
> http://lxr.linux.no/linux+v2.6.30/arch/powerpc/include/asm/irq.h#L29
> 
> For x86 it's not defined at all. But as this code is for the PowerPC,

No, it isn't. What makes you say that? The Kconfig entry doesn't depend
on PowerPC. I compiled it on x86...

> where using NO_IRQ seems still to be OK.

No. uio_pdrv_genirq can be used on all platforms, and not all platforms have
NO_IRQ. NO_IRQ can be used in platform specific code only.

Anyway, if someone fills in an invalid irq in his platform data, he deserves
to crash. No need for that test. UIO docs state that irq is a _required_
element. If you forget to set it, it will probably be 0. On most platforms,
register_irq will fail with that, and you'll notice. If you silently
replace it with UIO_IRQ_NONE, you simply cover up wrong code.

Thanks,
Hans

> 
> Wolfgang.
