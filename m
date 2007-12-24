Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbXLXMBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbXLXMBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 07:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXLXMBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 07:01:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57287 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbXLXMBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 07:01:31 -0500
Date: Mon, 24 Dec 2007 04:00:07 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
 driver opt-in issue
Message-ID: <20071224040007.1277fddd@laptopd505.fenrus.org>
In-Reply-To: <476F9DF6.60100@garzik.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
	<476D1D16.5090703@garzik.org>
	<20071222064719.73fdd9a4@laptopd505.fenrus.org>
	<alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
	<476DB95F.3090801@garzik.org>
	<alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
	<476DDFEE.3010009@garzik.org>
	<alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>
	<476DE98F.2010009@garzik.org>
	<20071223023348.348608a8@laptopd505.fenrus.org>
	<476F5A09.5010201@garzik.org>
	<20071224034935.600bdb30@laptopd505.fenrus.org>
	<476F9DF6.60100@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2007 06:54:30 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Arjan van de Ven wrote:
> > I can see the point of having a sysfs attribute to enable MMCONF
> > from userspace, so that userland diagnostics tools can turn it on
> > if they really really want to. (I'd make that printk a nice warning
> > "application XYZ is enabling extended config space for devize ABC"
> > so that if the box then crashes and burns, people know who/why and
> > where to direct their emails ;-)
> > 
> > We did something similar for "enable", it's maybe 10 lines of code
> > or so.
> > 
> > I would assume lspci and friends would then only turn that on at
> > explicit admin request
> 
> Absolutely...  I'm not asking to default it on, just asking for it to
> be possible :)
> 

ok so to summarize things a bit (I'll admit bias here but still ;)

1) having a per driver function to say "I'd like extended config space" is ok
   (it's the driver that knows what is needed after all)
2) we need a way for userspace to do the same for a given device
   (which then will print a nice warning who does what to whom)
3) we need to have the "no extended config space unless someone wants it" behavior
4) It's inevitable that this will end up being per device given that we'll end up with
   per device "this one is b0rked" quirks over time (even shortly)
5) architectures that have sane extended config space access should just be able to provide
   it always. This could even be on x86 based on BIOS date (say 2009 :)

the patch I posted does 1) 3) 4) and the first half of 5)
I'll update the patch to do 2) and the rest of 5)

Is there anything I skipped in the summary above?
(and yes I realize this needs lspci to be expanded some to set the flag if the admin really asks for it, 
but such is life)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
