Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbXLQNuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbXLQNuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXLQNuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:50:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45229 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbXLQNuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:50:08 -0500
Date: Mon, 17 Dec 2007 14:49:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Kaindl <bk@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Andi Kleen <ak@suse.de>,
       Bernhard Kaindl <bkaindl@ffii.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Thomas Renninger <trenn@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Early boot debugging via FireWire (ohci1394_dma=early)
Message-ID: <20071217134929.GJ1870@elte.hu>
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de> <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org> <4755D186.20204@s5r6.in-berlin.de> <4755D612.1090103@s5r6.in-berlin.de> <4755D757.7060002@s5r6.in-berlin.de> <alpine.LNX.0.9999-openSUSE-1.0712061732280.21849@jbgna.fhfr.qr> <alpine.LNX.0.9999-openSUSE-1.0712061936370.21849@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.0.9999-openSUSE-1.0712061936370.21849@jbgna.fhfr.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bernhard Kaindl <bk@suse.de> wrote:

> Subject of this patch:
> 
> This patch adds a new configuration option, which adds support for a 
> new early_param which gets checked in 
> arch/x86/kernel/setup_{32,64}.c:setup_arch() to decide wether 
> OHCI-1394 FireWire controllers should be initialized and enabled for 
> physical DMA access to allow remote debugging of early problems like 
> issues ACPI or other subsystems which are executed very early.
> 
> If the config option is not enabled, no code is changed, and if the 
> boot paramenter is not given, no new code is executed, and independent 
> of that, all new code is freed after boot, so the config option can be 
> even enabled in standard, non-debug kernels.
> 
> With specialized tools, it is then possible to get debugging 
> information from machines which have no serial ports (notebooks) such 
> as the printk buffer contents, or any data which can be referenced 
> from global pointers, if it is stored below the 4GB limit and even 
> memory dumps of of the physical RAM region below the 4GB limit can be 
> taken without any cooperation from the CPU of the host, so the machine 
> can be crashed early, it does not matter.

cool stuff! I've tentatively added your patch to x86.git (pending more 
review feedback from others), but it already looks quite nice to me.

	Ingo
