Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbXLKV3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbXLKV3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXLKV33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:29:29 -0500
Received: from smtp126.plus.mail.mud.yahoo.com ([209.191.106.157]:25979 "HELO
	smtp126.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751784AbXLKV32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:29:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=CHgVQAah5QoZOvGhJCeQ8V2J1j+saFTdxPKmojFPzitAo3OlQoo0WpT8VjyPXdA5uZTSG8DFCueDF4h3BsZ6dXV17TXygj6kLTKmnMPmJCvemHJsnJjBVGMarvab6nG5udvo/0zkka/AcW61Raa8BplyDl+96bSa4hFMhn05Tr8=  ;
X-YMail-OSG: _6lSpMcVM1m7iQgRIBVnzv7b3AUdVbC.R5dFXFbvrbhjRZrWTp4ISxqiylRmAGIPR9XUXYe89adtB_3ZZ76duycSThhNGsbtpKux7JN_BP_SA2P4V2A-
Date: Tue, 11 Dec 2007 21:52:55 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1: acpi reboots machine... solved
Message-ID: <20071211205255.GB5013@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071209075001.GA4686@gollum.tnic> <20071209091946.GA4501@gollum.tnic> <20071211174443.GA5013@gollum.tnic> <200712111300.24841.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712111300.24841.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 01:00:24PM -0700, Bjorn Helgaas wrote:
> On Tuesday 11 December 2007 10:44:43 am Borislav Petkov wrote:
> > On Sun, Dec 09, 2007 at 10:19:47AM +0100, Borislav Petkov wrote:
> > > On Sun, Dec 09, 2007 at 08:50:02AM +0100, Borislav Petkov wrote:
> > > > Hi Andrew,
> > > > Hi Len,
> > > > 
> > > > after booting 2.6.24-rc4-mm1 (2.6.24-rc4-190-g94545ba, otoh, boots just
> > > > fine) on my asus laptop, the machine reboots after claiming that
> > > > "Critical temperature reached (255 C)." However, the degrees number
> > > > is kinda hinting at 0xff all-ones field. Will try dump_stack in
> > > > acpi_thermal_critical() to checkout the call path. For now here's the netconsole bootlog:
> > > 
> > > Here's what i got so far:
> > > 
> > > [   50.287939] Pid: 1, comm: swapper Not tainted 2.6.24-rc4-mm1 #14
> > > [   50.287999]  [<c0104b65>] show_trace_log_lvl+0x12/0x25
> > > [   50.288103]  [<c01053e7>] show_trace+0xd/0x10
> > > [   50.288202]  [<c0105a6c>] dump_stack+0x57/0x5f
> > > [   50.288303]  [<c021c991>] acpi_thermal_check+0x150/0x3bb
> > > [   50.288415]  [<c021d4b3>] acpi_thermal_add+0x261/0x2cf
> > > [   50.288515]  [<c0213549>] acpi_device_probe+0x3e/0xdb
> > > [   50.288615]  [<c023f8f5>] driver_probe_device+0xaf/0x12a
> > > [   50.288717]  [<c023fa88>] __driver_attach+0x6c/0xa5
> > > [   50.288817]  [<c023ee5a>] bus_for_each_dev+0x3e/0x60
> > > [   50.288916]  [<c023f77d>] driver_attach+0x14/0x16
> > > [   50.289015]  [<c023f5a6>] bus_add_driver+0xa6/0x1a8
> > > [   50.289114]  [<c023fc53>] driver_register+0x42/0x47
> > > [   50.289214]  [<c02138c2>] acpi_bus_register_driver+0x3a/0x3c
> > > [   50.289316]  [<c044306b>] acpi_thermal_init+0x57/0x76
> > > [   50.289424]  [<c04344a7>] kernel_init+0x138/0x280
> > > [   50.289525]  [<c01047df>] kernel_thread_helper+0x7/0x10
> > > [   50.289625]  =======================
> > > [   50.289680] ACPI: Critical trip point
> > > [   50.289736] Critical temperature reached (255 C), shutting down.
> > > 
> > > so in acpi_thermal_get_temperature() called in acpi_thermal_add() the
> > > tz->temperature thingy is not set properly (printk's added):
> > > 
> > > [   50.276607] Old temp: 4294967023
> > > [   50.281890] Got temp: 255
> > > [   50.282567] Old temp: 255
> > > [   50.287882] Got temp: 255
> > > 
> > > What's also strange is that the tz acpi_thermal is alloc'd with kzalloc and
> > > there's still garbage in it after reading it in acpi_thermal_get_temperature()
> > > for the first time. Debugging continues...
> > 
> > (i almost suspected that the problem might be something completely different.)
> > well, after bisecting the rc4-mm1 tree for a whole day today, the evildoer
> > turned out to be
> > 
> > broken-out/pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch.
> > 
> > After backing this one out, mm1 boots just fine here.
> 
> Thanks for tracking this down.  I'll look into your logs and see if I
> can figure out what's going on.  There's another report related to that
> patch here: http://lkml.org/lkml/2007/11/22/110 .  Looks like a different
> symptom though, so probably a different fix.

>From what i can roughly tell so far it seems like an resource conflict between acpi and
the pnp requested regions in your patch which result in the acpi_thermal code
to read the wrong (0xff) temperature value and halt the machine, but i might be
wrong on the details since acpi is such a big code chunk to swallow. Anyways, this is a
different issue than the one you quote above.

-- 
Regards/Gruﬂ,
    Boris.
