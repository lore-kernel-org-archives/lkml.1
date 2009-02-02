Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbZBBMEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbZBBMEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZBBMEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:04:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZBBMEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:04:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [PATCH 2/3] PCI PM: Let the core be more careful with respect to drivers using new framework
Date: Mon, 2 Feb 2009 13:04:11 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200902012229.27517.rjw@sisk.pl> <200902012233.17790.rjw@sisk.pl> <1233540400.21871.7.camel@nigel-laptop>
In-Reply-To: <1233540400.21871.7.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902021304.12072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Nigel Cunningham wrote:
> Hi Rafael.
> 
> Just a couple of typos in the comment:
> 
> On Sun, 2009-02-01 at 22:33 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Currently, the PM core always attempts to manage devices with drivers
> > that use the new PM framework.  In particular, it attempts to disable
> > the devices (which is unnecessary), to save their state (which may be
> > undesirable if the driver has done that already) and to put them into
> > low power states (again, this may be undesirable if the driver has
> > already put the device into a low power state).  That need not be
> > the right thing to do, so make the core be more careful in this
> > respect.
> > 
> > Generally, there are the following categories of devices to consider:
> > * bridge devices without drivers
> > * non-bridge devices without drivers
> > * bridge devices with drivers
> > * non-bridge devices with drivers
> > and each of them should be handled differently.
> > 
> > For bridge devices without drivers the PCI PM core will save their
> > state on suspend and restore it (early) during resume, after putting
> > them into D0 if necessary.  It will not attepmt to do anything else
> 
> s/attepmt/attempt/

OK

> > to these devices.
> > 
> > For non-bridge devices without drivers the PCI PM core will disable
> > them and save their state on suspend.  During resume, it will put
> > them into D0, if necessary, restore their state (early) and reenable
> > them.
> > 
> > For bridge devices without drivers the PCI PM core will only save
> 
> s/without/with/

Ouch, thanks.

> > their state on suspend if the driver hasn't done that already.
> > Still, the core will restore their state (early) during resume,
> > after putting them into D0, if necessary.
> > 
> > For non-bridge devices with drivers the PCI PM core will only save
> > their state on suspend if the driver hasn't done that already.  Also,
> > if the state of the device hasn't been saved by the driver, the core
> > will attempt to put the device into a low power state.  During
> > resume the core will restore the state of the device (early), after
> > putting it into D0, if necessary.
> > 
> > For all devices the core will disable wake-up during resume.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> I'm not pretending to understand the gory details of the code itself,
> and so don't want you to add a Reviewed-by or such like for me, thanks.

Thanks for the fixes, I'll resend the patch with updated changelog.

Best,
Rafael
