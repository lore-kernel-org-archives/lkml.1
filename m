Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZA0Ijo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZA0Ijo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZA0Ije
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:39:34 -0500
Received: from mx1.wp.pl ([212.77.101.5]:13877 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbZA0Ijd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:39:33 -0500
Date: Tue, 27 Jan 2009 09:42:55 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <abelay@mit.edu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: How should I handle device with two PNP-BIOS ids?
Message-Id: <20090127094255.fc038987.krzysztof.h1@wp.pl>
In-Reply-To: <200901261513.32348.bjorn.helgaas@hp.com>
References: <497d80991ef709.35340258@wp.pl>
	<200901261513.32348.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [QYMk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 15:13:31 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> Hi Krzysztof,
> 
> Systems with the old chip probably report the device with a single
> PNP ID.  For PNPBIOS, that would be the "device product identifier."
> For ACPI, it would be the _HID.
> 
> Systems with the new chip should report both PNP IDs.  The PNPBIOS
> device product identifier or the ACPI _HID should be the new ID, and
> the older ID for backward compatibility should be reported in the
> PNPBIOS "compatible device identifiers" list or the ACPI _CID.
> 
> The driver would list both IDs in the pnp_device_id table, and it
> looks like the driver probe routine gets called with the ID that
> matched.
> 
> I don't see any drivers that actually do this, but I think the
> probe routine should be able to look at the ID that matched and
> determine whether the additional I/O range is present.
> 

The laptop in question is the Dell Latitude CPi and it does not
have ACPI only the PnP BIOS. 
The both ids are reported as unrelated (two separate nodes in 
the /sys/bus/pnp/). I don't know how to set up the "compatible device 
identifiers" list. It is not defined in the include/linux/pnp.h.
If I know that I will test this.

> Oops, looking at match_device() in drivers/pnp/driver.c, I think
> we look at all the device IDs supported by the driver, but we only
> look at the first ID associated with the device.  That means an old
> driver that only knows about the old device ID would fail to claim
> a new device (the new device will have the new ID first and old IDs
> in the compatibility list).  That looks like a bug in the PNP core --
> the old driver should be able to claim any new compatible devices.
> 
> Let me know if you think you're seeing this bug, and I'll look into
> it some more.
> 

Currently, I iterate over pnpbios_protocol to find out if the second 
id exists. It is not elegant but works.

Regards,
Krzysztof
