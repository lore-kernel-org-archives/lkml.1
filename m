Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbZA0RSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbZA0RSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZA0RR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:17:57 -0500
Received: from smtp6.welho.com ([213.243.153.40]:55152 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbZA0RR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:17:56 -0500
Date: Tue, 27 Jan 2009 19:17:52 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>, Adam Belay <abelay@mit.edu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: How should I handle device with two PNP-BIOS ids?
Message-ID: <20090127171752.GI4996@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Krzysztof Helt <krzysztof.h1@wp.pl>, Adam Belay <abelay@mit.edu>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <497d80991ef709.35340258@wp.pl> <200901261513.32348.bjorn.helgaas@hp.com> <20090127094255.fc038987.krzysztof.h1@wp.pl> <200901270852.52153.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901270852.52153.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 08:52:51AM -0700, Bjorn Helgaas wrote:
> On Tuesday 27 January 2009 01:42:55 am Krzysztof Helt wrote:
> > On Mon, 26 Jan 2009 15:13:31 -0700
> > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > Systems with the old chip probably report the device with a single
> > > PNP ID.  For PNPBIOS, that would be the "device product identifier."
> > > For ACPI, it would be the _HID.
> > > 
> > > Systems with the new chip should report both PNP IDs.  The PNPBIOS
> > > device product identifier or the ACPI _HID should be the new ID, and
> > > the older ID for backward compatibility should be reported in the
> > > PNPBIOS "compatible device identifiers" list or the ACPI _CID.
> > > 
> > > The driver would list both IDs in the pnp_device_id table, and it
> > > looks like the driver probe routine gets called with the ID that
> > > matched.
> > > 
> > > I don't see any drivers that actually do this, but I think the
> > > probe routine should be able to look at the ID that matched and
> > > determine whether the additional I/O range is present.
> > 
> > The laptop in question is the Dell Latitude CPi and it does not
> > have ACPI only the PnP BIOS. 
> > The both ids are reported as unrelated (two separate nodes in 
> > the /sys/bus/pnp/).
> 
> Oh.  That sounds like a BIOS bug.  If there's only one actual
> chip, the BIOS should not report it as two separate devices.

It's not a bug. The cs423x chips contain several logical devices.
WSS, MPU401, joystick etc. The control logical device (which is
not present in the early models) is unfortunately some kind of dumping
ground for new registers to keep the other logical devices' backwards
compatible. It contains at least some extra mixer control registers and
power management registers.

The datasheets are available at ftp.alsa-project.org.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
