Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYE1Koz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYE1Koz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 06:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYE1Kos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 06:44:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59684 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbYE1Kor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 06:44:47 -0400
Date: Wed, 28 May 2008 12:42:50 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: amd64-agp: resume but too late?
Message-ID: <20080528104250.GC5728@elf.ucw.cz>
References: <20080526182904.GA13683@elf.ucw.cz> <alpine.LFD.1.10.0805271415160.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805271415160.3295@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-05-27 14:18:19, Thomas Gleixner wrote:
> On Mon, 26 May 2008, Pavel Machek wrote:
> > Hi!
> > 
> > I don't get it:
> > 
> > --- a/drivers/char/agp/amd64-agp.c
> > +++ b/drivers/char/agp/amd64-agp.c
> > @@ -549,6 +549,8 @@ static int agp_amd64_suspend(struct pci_
> >         return 0;
> >  }
> >  
> > +/* FIXME: this is strange; we enable iommu translation here, but that
> > + * may be too late, no? */
> >  static int agp_amd64_resume(struct pci_dev *pdev)
> >  {
> >         pci_set_power_state(pdev, PCI_D0);
> > 
> > ...but resume is normal pci device, so other devices may be resumed
> > before this one, and already depend on iommu running...
> > 
> > How is this supposed to work? Should agp_amd64_resume be called from
> > sysdev or something like that?
> 
> Hmm, you sent a patch some days ago to change it to
> suspend_late/resume_early. Is the discussion resolved about that ?

I'm not aware of such patch. I don't think I sent it.

I did add suspend/resume support to pci-gart_64.c , which is
confusingly similar code. That patch needs a bit more testing, and
some de-uglyfication.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
