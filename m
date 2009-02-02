Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZBBCGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZBBCGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 21:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZBBCGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 21:06:14 -0500
Received: from mail.crca.org.au ([67.207.131.56]:41471 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbZBBCGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 21:06:13 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [PATCH 2/3] PCI PM: Let the core be more careful
 with respect to drivers using new framework
From: Nigel Cunningham <ncunningham@crca.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200902012233.17790.rjw@sisk.pl>
References: <200902012229.27517.rjw@sisk.pl>
	 <200902012233.17790.rjw@sisk.pl>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Mon, 02 Feb 2009 13:06:40 +1100
Message-Id: <1233540400.21871.7.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

Just a couple of typos in the comment:

On Sun, 2009-02-01 at 22:33 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Currently, the PM core always attempts to manage devices with drivers
> that use the new PM framework.  In particular, it attempts to disable
> the devices (which is unnecessary), to save their state (which may be
> undesirable if the driver has done that already) and to put them into
> low power states (again, this may be undesirable if the driver has
> already put the device into a low power state).  That need not be
> the right thing to do, so make the core be more careful in this
> respect.
> 
> Generally, there are the following categories of devices to consider:
> * bridge devices without drivers
> * non-bridge devices without drivers
> * bridge devices with drivers
> * non-bridge devices with drivers
> and each of them should be handled differently.
> 
> For bridge devices without drivers the PCI PM core will save their
> state on suspend and restore it (early) during resume, after putting
> them into D0 if necessary.  It will not attepmt to do anything else

s/attepmt/attempt/

> to these devices.
> 
> For non-bridge devices without drivers the PCI PM core will disable
> them and save their state on suspend.  During resume, it will put
> them into D0, if necessary, restore their state (early) and reenable
> them.
> 
> For bridge devices without drivers the PCI PM core will only save

s/without/with/

> their state on suspend if the driver hasn't done that already.
> Still, the core will restore their state (early) during resume,
> after putting them into D0, if necessary.
> 
> For non-bridge devices with drivers the PCI PM core will only save
> their state on suspend if the driver hasn't done that already.  Also,
> if the state of the device hasn't been saved by the driver, the core
> will attempt to put the device into a low power state.  During
> resume the core will restore the state of the device (early), after
> putting it into D0, if necessary.
> 
> For all devices the core will disable wake-up during resume.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

I'm not pretending to understand the gory details of the code itself,
and so don't want you to add a Reviewed-by or such like for me, thanks.

Regards,

Nigel

