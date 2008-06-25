Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYFYWYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYFYWYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYFYWYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:24:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49022 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYFYWYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:24:44 -0400
Date: Thu, 26 Jun 2008 00:25:43 +0200
From: Pavel Machek <pavel@suse.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: pci-gart_64.c: could we get better explanation?
Message-ID: <20080625222543.GD1844@elf.ucw.cz>
References: <20080526184703.GA17369@elf.ucw.cz> <1211831499.3286.2.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211831499.3286.2.camel@pasglop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-05-27 05:51:39, Benjamin Herrenschmidt wrote:
> 
> On Mon, 2008-05-26 at 20:47 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > +++ b/arch/x86/kernel/pci-gart_64.c
> > @@ -774,6 +778,7 @@ #endif
> >  
> >         /*
> >          * Try to workaround a bug (thanks to BenH)
> >          * Set unmapped entries to a scratch page instead of 0.
> >          * Any prefetches that hit unmapped entries won't get an bus abort
> > 
> > Could someone explain? Which bug is being worked around? CPUs
> > prefetching over NULL?
> 
> P2P bridge prefetching on DMA reads.

---

Add better explanation to pci-gart.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 838a1d3..e72e583 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -800,10 +800,10 @@ #endif
 	wbinvd();
 
 	/*
-	 * Try to workaround a bug (thanks to BenH)
+	 * Try to workaround a bug (thanks to BenH):
 	 * Set unmapped entries to a scratch page instead of 0.
 	 * Any prefetches that hit unmapped entries won't get an bus abort
-	 * then.
+	 * then. (P2P bridge may be prefetching on DMA reads).
 	 */
 	scratch = get_zeroed_page(GFP_KERNEL);
 	if (!scratch)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
