Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYKXXCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYKXXCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYKXXCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:02:24 -0500
Received: from mail04.solnet.ch ([212.101.4.138]:49949 "EHLO mail04.solnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbYKXXCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:02:23 -0500
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
From: Cristiano Prisciandaro <cristiano.p@solnet.ch>
To: Thomas Renninger <trenn@suse.de>
Cc: Tom Hughes <tom@compton.nu>, Dave Jones <davej@redhat.com>,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net
In-Reply-To: <200811241736.53067.trenn@suse.de>
References: <1227454026.7262.59.camel@localhost>
	 <492A7632.4040106@compton.nu> <200811241613.25557.trenn@suse.de>
	 <200811241736.53067.trenn@suse.de>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 00:02:19 +0100
Message-Id: <1227567739.6421.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 17:36 +0100, Thomas Renninger wrote:
> On Monday 24 November 2008 04:13:24 pm Thomas Renninger wrote:
> > On Monday 24 November 2008 10:38:58 am Tom Hughes wrote:
> > > Cristiano Prisciandaro wrote:
> > > > From: Cristiano Prisciandaro <cristiano.p@solnet.ch>
> > > >
> > > > The bios of the eeepc 900 exposes an acpi method that allows clocking
> > > > the cpu to 630/900 MHz. This driver allows controlling the frequency
> > > > switch through the cpufreq subsystem.
> > >
> > > I should perhaps add at this point that I have an alternative patch
> > > based on Cristiano's code, which adds this cpufreq driver to the
> > > existing eeepc-laptop module rather than creating a separate module for
> > > it.
> > >
> > > Personally I'm quite happy with either solution so I'll leave it to you
> > > to decide what is the best way to go, but my patch is available if you
> > > want it.
> >
> > Either way, shouldn't you be able to provide a dmi matching module alias:
> > MODULE_ALIAS("dmi:...")
> > for autoloading?
> >
> > Or are these two cpufreq functions part of an ACPI device you could match
> > for, then it should get an ACPI driver?
> Oh, they are part of this general Asus \\_SB.ATKD device, which is only
> used by asus_laptop.c until now?
> I don't know \\_SB.ATKD in detail, but it has not a HID to match against and 
> contains ASUS specific ACPI helper functions?
> 
> Looks like a growing mess in the ASUS ACPI area...
> 
> Some more questions:
> Why are they providing their own cpufreq interface and not following the
> spec (providing _PSS, ..)?
> Could it be that you are only throttling the CPU?
This eeepc is equipped with a Celeron-M ULV 353 with no clock-varying
technology support but the frequency change seems to be achieved by
changing FSB clock and cpu voltage (method FSBA).

Before bios ver. 0501 asus provided an option to switch the operation
mode of the eeepc 900 to powersave/performance: this allowed to decide a
fixed frequency at boot (630/900 MHz).

The asus-acpi module exposed this functions into the proc FS: you could
echo 0 or 1 to /proc/acpi/asus/cpufv to change the frequency. 
This is the method used in the stock xandros distribution to switch to
powersave/performance mode when the power supply gets connected or
disconnected (using an acpi script).

> Are these functions already used by the ACPI tables internally?
There are 2 methods in the DSDT where the presence of the power supply
is checked and the frequency set accordingly:

INIT (only in newer bios versions)
_Q31

but both seem to do the job just for the windoz flavour.

>   - could be dangerous
As this function seem to be used by asus, I don't think it is dangerous.
Probably switching too many times per second ...

This is not a good argumentation, so please skip the next lines:
I can only say that my machine (and at least Tom's one) is still
alive after months using the module ...

>   - could be helpful -> Is there some upper level device/interface in ASL?
As I said before, in the stock distribution the frequency seems to be
controlled only through the proc interface and some acpi scripts: I
don't think there is some higher level controller.

> Could it happen that upcoming machines provide this interface (the two ACPI 
> functions) and also can do real CPU frequency/volt switching, e.g. via 
> acpi-cpufreq?

Probably this interface is a solution specific to machines based on the
celeron M: I don't even know if other 'old' models provide the same
interface.

   cristiano

