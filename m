Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZFHSiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZFHSiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbZFHSiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:38:19 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:39385 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZFHSiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:38:18 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH 2/2] CPUFREQ: Mark e_powersaver driver as EXPERIMENTAL and DANGEROUS
Date: Mon, 8 Jun 2009 13:38:14 -0500
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <20090608102936.GQ4106@prithivi.gnumonks.org> <20090608120846.GA13328@srcf.ucam.org> <20090608181335.GC4455@prithivi.gnumonks.org>
In-Reply-To: <20090608181335.GC4455@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081338.18227.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 8 2009, Harald Welte wrote:
> On Mon, Jun 08, 2009 at 01:08:46PM +0100, Matthew Garrett wrote:
> > On Mon, Jun 08, 2009 at 06:29:36PM +0800, Harald Welte wrote:
> > > The e_powersaver driver for VIA's C7 CPU's needs to be marked as
> > > DANGEROUS as it configures the CPU to power states that are out
> > > of specification.
> > > 
> > > According to Centaur, all systems with C7 and Nano CPU's support
> > > the ACPI p-state method.  Thus, the acpi-cpufreq driver should
> > > be used instead.
> > 
> > Do we know if vendors are actually shipping with the appropriate BIOS 
> > tables? 
> 
> I strongly assume so, since that is also how the Windows XP driver works (as
> I've been told by Centaur).  So if a vendor decides to not ship with the
> respective BIOS tables, the power management would fail on Windows, too.
> 
> > The number of people using e_powersaver seems to be suspiciously 
> > large, though perhaps that's just because the help text implied it was 
> > the right choice for C7.
> 
> yes, I think that is the case.  I just had a brief look at the driver earlier
> today with one of the key Centaur engineers, and he was very clear on it:  Use 
> ACPI.
> 
> There are also other reasons to use ACPI.  Let's imagine you are having a
> system that uses a certain cpu that might clock up to 1600 MHz.  But the system
> vendor decides to use the CPU passively cooled and thus wants to restrict the
> frequency to 1300MHz.  The standard practise (as recommended by VIA/Centaur BIOS
> writers guide) is to remove the > 1300MHz p-states from the ACPI tables.
> 
> So even if e_powersaver was fixed to not drive the CPU out of spec, it might
> still do that on a particular system/board, where the vendor has decided to 
> limit CPU clock for cooling reasons.
> 

I have yet to run either of my machines using only the internal adaptive controller;
__BUT__
As I read the information, under a limited cooling condition it would be safe and
stable **for the silicon** - -
But for a machine that could come into contact with human skin... that might do harm.
Skin doesn't have the heat tolerance these silicon devices do.  ;)

For an embedded appliance, or something else protected from human contact, perhaps
with no or limited BIOS support - the internal adaptive controller sounds like the
thing to be used.

Since the acpi driver will have to have the code to identify if the internal 
controller is enabled and disable it - I am considering a acpi_cpu=internal
command line flag to let the (soon to be) acpi driver just enable the internal
controller and *not* turn over control to the acpi.
This would be of interest to builders of those embedded appliances and only
would add a few lines of code to an __init section.

Mike

