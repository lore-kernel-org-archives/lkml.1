Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbZAGXDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbZAGXDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZAGXDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:03:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48376 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZAGXDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:03:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [RFC][PATCH 5/10] PCI PM: Avoid touching devices behind bridges in unknown state (rev. 2)
Date: Thu, 8 Jan 2009 00:02:54 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200812190049.34343.rjw@sisk.pl> <200901051430.55649.rjw@sisk.pl> <20090107223225.GE2101@elf.ucw.cz>
In-Reply-To: <20090107223225.GE2101@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901080002.55603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009, Pavel Machek wrote:
> On Mon 2009-01-05 14:30:54, Rafael J. Wysocki wrote:
> > On Monday 05 January 2009, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > Subject: PCI PM: Avoid touching devices behind bridges in unknown state (rev. 2)
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > It generally is better to avoid accessing devices behind bridges that
> > > > may not be in the D0 power state, because in that case the bridges'
> > > > secondary buses may not be accessible.  For this reason, during the
> > > > early phase of resume (ie. with interrupts disabled), before
> > > > restoring the standard config registers of a device, check the power
> > > > state of the bridge the device is behind and postpone the restoration
> > > > of the device's config space, as well as any other operations that
> > > > would involve accessing the device, if that state is not D0.
> > > 
> > > I'm not sure if this is good idea.
> > > 
> > > Either pci config space needs to be restored early, or it can wait.
> > > 
> > > Sometimes restoring it early and sometimes restoring it late seems
> > > harmful: it will make code harder to understand and harder to test.
> > 
> > Unfortunately, we need to restore it early at least for some devices (bridges
> > and PCI Express ports) and I don't think it is generally safe to go and restore
> > it early for every device (as explained in this changelog).
> 
> Could we make it so that it is restored early exactly on bridges and
> PCIe ports?
> 
> Idea that restore of one specific device is called early or late
> depending if it is connected directly or behind bridge scares me...

There's nothing scary in it IMO and in fact the device's config space is
always restored as soon as reasonably possible.

It will be restored early even if it is behind a bridge, unless that bridge
itself is in a low power state, in which case clearly we _can't_ restore it
early.

Thanks,
Rafael
