Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbZAGWdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbZAGWdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932506AbZAGWa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:30:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49491 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762348AbZAGWaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:30:25 -0500
Date: Wed, 7 Jan 2009 23:32:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [RFC][PATCH 5/10] PCI PM: Avoid touching devices behind
	bridges in unknown state (rev. 2)
Message-ID: <20090107223225.GE2101@elf.ucw.cz>
References: <200812190049.34343.rjw@sisk.pl> <200901012209.47598.rjw@sisk.pl> <20090105105830.GH27199@atrey.karlin.mff.cuni.cz> <200901051430.55649.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901051430.55649.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-05 14:30:54, Rafael J. Wysocki wrote:
> On Monday 05 January 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > Subject: PCI PM: Avoid touching devices behind bridges in unknown state (rev. 2)
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > It generally is better to avoid accessing devices behind bridges that
> > > may not be in the D0 power state, because in that case the bridges'
> > > secondary buses may not be accessible.  For this reason, during the
> > > early phase of resume (ie. with interrupts disabled), before
> > > restoring the standard config registers of a device, check the power
> > > state of the bridge the device is behind and postpone the restoration
> > > of the device's config space, as well as any other operations that
> > > would involve accessing the device, if that state is not D0.
> > 
> > I'm not sure if this is good idea.
> > 
> > Either pci config space needs to be restored early, or it can wait.
> > 
> > Sometimes restoring it early and sometimes restoring it late seems
> > harmful: it will make code harder to understand and harder to test.
> 
> Unfortunately, we need to restore it early at least for some devices (bridges
> and PCI Express ports) and I don't think it is generally safe to go and restore
> it early for every device (as explained in this changelog).

Could we make it so that it is restored early exactly on bridges and
PCIe ports?

Idea that restore of one specific device is called early or late
depending if it is connected directly or behind bridge scares me...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
