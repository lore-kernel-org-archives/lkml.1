Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYCZXE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYCZXE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYCZXEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:04:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55177 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbYCZXEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:04:20 -0400
Date: Thu, 27 Mar 2008 00:05:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080326230500.GB9378@elf.ucw.cz>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org> <20080326102151.GB18965@elf.ucw.cz> <20080326130052.GF2170@one.firstfloor.org> <20080326225407.GA9378@elf.ucw.cz> <20080326230017.GA21017@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326230017.GA21017@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-27 00:00:17, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > @@ -733,8 +735,8 @@ static struct pci_driver agp_amd64_pci_d
> >  	.probe		= agp_amd64_probe,
> >  	.remove		= agp_amd64_remove,
> >  #ifdef CONFIG_PM
> > -	.suspend	= agp_amd64_suspend,
> > -	.resume		= agp_amd64_resume,
> > +	.suspend_late	= agp_amd64_suspend,
> > +	.resume_early	= agp_amd64_resume,
> >  #endif
> 
> ah, makes sense. I've queued up your fix in x86.git (sans the debug 
> printks), please send your signoff once you can verify that it solves 
> the hibernation hang on your box and we'll push it into 2.6.25.

I've not even compiled it. It is obviously 

Signed-off-by: Pavel Machek <pavel@suse.cz>

(it is GPLed) ...but it is totally untested, and probably same fix
needs to go to all the agp drivers...?

I'll test it tommorow.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
