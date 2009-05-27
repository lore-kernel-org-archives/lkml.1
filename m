Return-Path: <linux-kernel-owner+w=401wt.eu-S1761987AbZE0KBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987AbZE0KBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 06:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760745AbZE0KB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 06:01:27 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:59468 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760628AbZE0KB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 06:01:26 -0400
Date: Wed, 27 May 2009 11:59:10 +0200
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Message-ID: <20090527095910.GA31832@mea.homelinux.org>
References: <20090512100523.GA31131@mea.homelinux.org> <4A0A05FC.10906@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A0A05FC.10906@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Mats Erik Andersson <mats.andersson@gisladisker.se>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, trivial@kernel.org
X-SA-Exim-Mail-From: mats.andersson@gisladisker.se
Subject: Re: [PATCH 1/1] pci: expose SMBus on Asus notebook A6L
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on aun.utmark.mea)
X-Originating-IP: 83.253.254.238
X-Scan-Result: No virus found in message 1M9Fwl-0004QV-8N.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1M9Fwl-0004QV-8N 60e1e056b08e59b07fa791d0d03d994a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware observation on my suggested patch.

tisdag den 12 maj 2009 klockan 17:27 skrev Robert Hancock detta:
> Mats Erik Andersson wrote:
> >From: Mats Erik Andersson <mats.andersson@gisladisker.se>
> >
> >Addition of one unknown subsystem identifier to the
> >quirks handler for chipset i82855GM_HB on notebook
> >Asus A6L. This exposes the otherwise hidden SMBus
> >controller within the south bridge ICH4-M.
> >
> >Signed-off-by: Mats Erik Andersson <mats.andersson@gisladisker.se>
> >---
> >
> >Tried and successfully used on kernel 2.6.29 and 2.6.23.17.
> >
> >--- drivers/pci/quirks.c.orig	2009-05-09 00:47:21.000000000 +0200
> >+++ drivers/pci/quirks.c	2009-05-12 11:20:04.000000000 +0200
> >@@ -1068,8 +1068,9 @@ static void __init asus_hides_smbus_host
> > 		else if (dev->device == PCI_DEVICE_ID_INTEL_82855GM_HB)
> > 			switch (dev->subsystem_device) {
> > 			case 0x1751: /* M2N notebook */
> > 			case 0x1821: /* M5N notebook */
> >+			case 0x1897: /* A6L notebook */
> > 				asus_hides_smbus = 1;
> > 			}
> > 		else if (dev->device == PCI_DEVICE_ID_INTEL_82855PM_HB)
> > 			switch (dev->subsystem_device) {
> 
> This has to be done with caution. If the BIOS accesses the SMBus 
> controller from ACPI AML code or SMI code, then allowing a Linux driver 
> to access the controller may cause problems.

My notebook Asus A6L can use the driver it87-isa without any
modification to the vanilla kernel, but that only exposes the
fan sensors and it only claims 0 RPM for all three measurements.
I have been dissatisfies with the fan control for three years now,
since it never completely slows down!

When exposing the hidden SMBus, thus using driver max6657-i2c,
the temperature sensors for motherboard and cpu becomes accessible
for lm-sensors for the first time. However, this cpu temperature
coincides with the claims done by the proc-acpi entry. 

I am since some time now using a recompiled kernel with my suggested
patch activated, and I have as of yet not noticed any difference
in system behaviour. On the other hand I still cannot silence
the fan.

Regards

Mats Erik Andersson


