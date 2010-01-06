Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050Ab0AFXLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0AFXLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615Ab0AFXLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:11:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41022 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab0AFXLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:11:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 9/12] ACPI / PM: Introduce acpi_pm_wakeup_power()
Date: Thu, 7 Jan 2010 00:11:49 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <200912272057.10443.rjw@sisk.pl> <200912272106.26569.rjw@sisk.pl> <20100106140035.6f622acf@jbarnes-piketon>
In-Reply-To: <20100106140035.6f622acf@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001070011.49755.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 January 2010, Jesse Barnes wrote:
> On Sun, 27 Dec 2009 21:06:26 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >  /**
> > + * acpi_pm_wakeup_power - Enable/disable device wake-up power.
> > + * @dev: ACPI device to handle.
> > + * @enable: Whether to enable or disable the wake-up power of the
> > device.
> > + */
> > +int acpi_pm_wakeup_power(struct acpi_device *dev, bool enable)
> > +{
> 
> I know we've got these all over now, but functions that just take a
> bool are generally hard to read when you just look at the call site.
> If it was called "acpi_pm_set_wakeup_power" and then took an on/off
> enum it would be really easy to see, from the callsite, what was going
> on.
> 
> It's a fairly minor complaint, but it's something that's always bugged
> me about the PCI PM code in particular.

Well, in this particular case acpi_pm_wakeup_power() uses a bool, because
acpi_pm_device_sleep_wake() (which is a caller of it) does.  IMO it won't
be logical to use something else just here.

Also, as you noticed above, this follows a convention used not only in the
PCI PM, but generally in the core PM code.  Although we could change this
convention, I'm not really sure that would be worth the effort.

Rafael
