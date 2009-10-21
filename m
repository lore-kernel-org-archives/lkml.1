Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZJURhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZJURhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 13:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZJURhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 13:37:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39488 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbZJURhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 13:37:45 -0400
Date: Wed, 21 Oct 2009 10:37:33 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Crane Cai <crane.cai@amd.com>, lenb@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] i2c-scmi: Quirk to work on IBM machines with broken
	BIOSes
Message-ID: <20091021173733.GN26149@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20091020231149.GM26149@tux1.beaverton.ibm.com> <20091021023016.GC32413@crane-desktop> <200910210857.13978.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910210857.13978.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 08:57:13AM -0600, Bjorn Helgaas wrote:
> On Tuesday 20 October 2009 08:30:16 pm Crane Cai wrote:
> > Hi Darrick,
> > 
> > On Tue, Oct 20, 2009 at 04:11:49PM -0700, Darrick J. Wong wrote:
> > > On some old IBM workstations and desktop computers, the BIOS presents in
> > > the DSDT an SMBus object that is missing the HID identifier that the
> > > i2c-scmi driver looks for.  It also omits the leading "_" in the method
> > > names (it should be _SBR, not SBR_).  Modify the ACPI device scan code to
> > > insert the missing HID if it finds an IBM system with such an object, and
> > > modify the i2c-scmi driver to handle the odd method names.
> > I have a suggestion: You can need not to add quirk in acpi part, instead
> > you can add your ACPI device HID in i2c-scmi with your specificied methods
> > set.

The problem is that the BIOS does not provide an HID for the SMBus object at
all...

> Maybe Darrick understands your suggestion, but I don't.  The only way
> i2c-scmi ever learns about a device is when acpi_smbus_cmi_add() is
> called, and that's only called when the Linux/ACPI core has found a
> device that matches "SMBUS01".
> 
> Can you elaborate on your suggestion?
> 
> The i2c-scmi driver *could* walk the whole namespace itself, looking
> for devices with the SBI/SBR/SBW methods, but I like Darrick's quirk
> approach better because it allows i2c-scmi to continue to use the
> normal ACPI driver model.

...which is why I need the quirk to stuff one in at the OS level.  Were it as
simple as recognizing a different HID, I could have written a less intrusive
patch. :/

--D
