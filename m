Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbXLLQV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbXLLQV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXLLQVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:21:47 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:38407 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbXLLQVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:21:45 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: bbpetkov@yahoo.de
Subject: Re: 2.6.24-rc4-mm1: acpi reboots machine... solved
Date: Wed, 12 Dec 2007 09:21:41 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071209075001.GA4686@gollum.tnic> <200712111709.00313.bjorn.helgaas@hp.com> <20071212101123.GA5619@gollum.tnic>
In-Reply-To: <20071212101123.GA5619@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712120921.42430.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2007 03:11:23 am Borislav Petkov wrote:
> On Tue, Dec 11, 2007 at 05:08:59PM -0700, Bjorn Helgaas wrote:
> > On Tuesday 11 December 2007 01:52:55 pm Borislav Petkov wrote:
> > > From what i can roughly tell so far it seems like an resource conflict between acpi and
> > > the pnp requested regions in your patch which result in the acpi_thermal code
> > > to read the wrong (0xff) temperature value and halt the machine, but i might be
> > > wrong on the details since acpi is such a big code chunk to swallow.
> > 
> > I don't see any obvious conflict from the log you posted.  For the sake
> > of comparison, can you post the corresponding dmesg log after you removed
> > the patch?
> 
> The only difference i see is that ACPI finds EC in DSDT in the working kernel
> and in the broken case something silently fails. Please find attached the 2 bootlogs
> and a disassembled DSDT.

Thanks very much!

"ACPI: EC: Look up EC in DSDT" appears in the working log, but not
in the broken one.  But I think we *do* find the EC in both cases,
because we see "ACPI: EC: non-query interrupt received" even before
acpi_ec_add() (which prints the "ACPI: EC: GPE = 0x1c, ...".  Maybe
the logs were collected with different log levels?

I think Alexey is on the right track with the PCI resource allocation
failure.  On your working kernel, can you collect this:

  lspci -vv > lspci
  cat /proc/ioports > ioports
  cat /proc/iomem > iomem
  grep . /sys/devices/pnp*/*/resources > pnp
  tar -jcf resources.tar.bz2 lspci ioports iomem pnp

Bjorn
