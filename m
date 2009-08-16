Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZHPPYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZHPPYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZHPPYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:24:11 -0400
Received: from smtp-out-092.synserver.de ([212.40.180.92]:1033 "HELO
	smtp-out-092.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754682AbZHPPYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:24:10 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 20151
Date: Sun, 16 Aug 2009 17:24:08 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Calvin Walton <calvin.walton@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] [hwmon] linux 2.6.31-rc6 regression
Message-ID: <20090816152408.GA1951@phenom2.trippelsdorf.de>
References: <12d7e64c0908150329k1bf123der18e74112c5b9cd97@mail.gmail.com>
 <20090816010303.GA9588@srcf.ucam.org>
 <20090816053735.GB1998@phenom2.trippelsdorf.de>
 <1250432893.7591.5.camel@ayu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1250432893.7591.5.camel@ayu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 10:28:13AM -0400, Calvin Walton wrote:
> On Sun, 2009-08-16 at 07:37 +0200, Markus Trippelsdorf wrote:
> > On Sun, Aug 16, 2009 at 02:03:03AM +0100, Matthew Garrett wrote:
> > > On Sat, Aug 15, 2009 at 01:29:48PM +0300, Zeev Tarantov wrote:
> > > 
> > > > [    3.276720] w83627ehf: Found W83627DHG chip at 0x290
> > > > [    3.276894] ACPI: I/O resource w83627ehf [0x295-0x296] conflicts
> > > > with ACPI region HWRE [0x290-0x299]
> > > > [    3.277171] ACPI: Device needs an ACPI driver
> > > 
> > > The hwmon driver is attempting to allocate a region that's also used by 
> > > your ACPI firmware. There's no way to synchronise access between the 
> > > kernel and the firmware, so allowing both is potentially racy - we've 
> > > seen numerous cases where the combination results in the system 
> > > incorrectly generating critical temperatuer shutdowns, for instance, 
> > > when some other indexed access gets interpreted as the temperature or 
> > > when the hwmon chip's state machine is confused. The failure of hwmon to 
> > > bind is a feature here, not a bug. You can override it with 
> > > acpi_enforce_resources=no on the kernel command line.
> > 
> > But we don't introduce »features« that break hardware monitoring on
> > numerous machines in rc6 normally, IIRC.
> > If this so important and critical to you, than just add a »hyperstrict«
> > parameter to acpi_enforce_resources or make »lax« the default.
> 
> Note that, as this is an ASUS board, there is actually an ACPI firmware
> driver available that will let you do hardware monitoring in a way that
> doesn't conflict with the firmware - give the "ASUS ATK0110 ACPI hwmon"
> driver a try.

Thanks for the hint. I had to patch lm_sensors, but now everything is
working fine. The output of sensors is also much nicer.

(http://lists.lm-sensors.org/pipermail/lm-sensors/2008-June/023606.html)

-- 
Markus
