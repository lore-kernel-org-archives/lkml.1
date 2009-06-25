Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbZFYMs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZFYMs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZFYMsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:48:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49713 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbZFYMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:48:21 -0400
Date: Thu, 25 Jun 2009 13:49:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David =?ISO-8859-14?B?SORyZGVtYW4=?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, jesse.barnes@intel.com
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP
      id WEC1022)
Message-ID: <20090625134946.46109bac@lxorguk.ukuu.org.uk>
In-Reply-To: <55ca74318001aae803805a7bccfaca36.squirrel@www.hardeman.nu>
References: <20090624213645.GA18843@hardeman.nu>
	<20090624234501.3d35642f@lxorguk.ukuu.org.uk>
	<55ca74318001aae803805a7bccfaca36.squirrel@www.hardeman.nu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How would it work in conjunction with ACPI? When I looked at the ACPI
> dumps for my motherboard, the AML code seemed happy to fiddle with global
> SuperI/O registers (protected using an internal mutex).

If the device is ACPI managed in this way then all accesses to all devices
at that address must go via ACPI as I understand it.

> Also, I don't think it's very user-friendly to have a IR device show up as
> /dev/tty...how would userspace be able to find out that it's actually an
> IR transceiver?

Thats easy to fix - the question is more "is it an 8250 UART with some
quirks" or is it best driven by another device.

You can certainly stop the serial layer grabbing it (or undo that)
providing the port isn't the console (which in this case would make no
sense).

> Therefore I still think it's better to model the driver as an input
> device, and ultimately to teach the input subsystem some specifics of CIR
> devices, similar to how force-feedback devices are handled today.

Seems reasonable for this device.

Alan
