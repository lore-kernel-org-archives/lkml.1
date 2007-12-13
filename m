Return-Path: <linux-kernel-owner+w=401wt.eu-S1765093AbXLMHWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765093AbXLMHWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763680AbXLMHK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:10:57 -0500
Received: from smtp104.plus.mail.re1.yahoo.com ([69.147.102.67]:27737 "HELO
	smtp104.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763673AbXLMHKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:10:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=4ePIKB2LYzyAm4kOjTOXEysEhZFjYFAaavWh+P5YSaUiAn3XnEwxEyMNKvbD4zUDGFfyb2JmFGRWSdtv8gTNRlSl9rzrp0/Yv0iFwsOQQuDNwd0SHI5T0degsS8pI1lfsNSka3RJ3m4OolQnG5Sj2BjeV6hCtUARlLm5MYOItZE=  ;
X-YMail-OSG: 5WiEER0VM1nYWqjMv5dlo0PV5uwOg8XQyACDXsSXfl5LlY0Go2g4cjBdvXs.Vg53USb8rg1EPQ--
Date: Thu, 13 Dec 2007 08:09:23 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1: acpi reboots machine... solved
Message-ID: <20071213070923.GA3951@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071209075001.GA4686@gollum.tnic> <200712111709.00313.bjorn.helgaas@hp.com> <20071212101123.GA5619@gollum.tnic> <200712120921.42430.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712120921.42430.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Dec 12, 2007 at 09:21:41AM -0700, Bjorn Helgaas wrote:
> On Wednesday 12 December 2007 03:11:23 am Borislav Petkov wrote:
> > On Tue, Dec 11, 2007 at 05:08:59PM -0700, Bjorn Helgaas wrote:
> > > On Tuesday 11 December 2007 01:52:55 pm Borislav Petkov wrote:
> > > > From what i can roughly tell so far it seems like an resource conflict between acpi and
> > > > the pnp requested regions in your patch which result in the acpi_thermal code
> > > > to read the wrong (0xff) temperature value and halt the machine, but i might be
> > > > wrong on the details since acpi is such a big code chunk to swallow.
> > > 
> > > I don't see any obvious conflict from the log you posted.  For the sake
> > > of comparison, can you post the corresponding dmesg log after you removed
> > > the patch?
> > 
> > The only difference i see is that ACPI finds EC in DSDT in the working kernel
> > and in the broken case something silently fails. Please find attached the 2 bootlogs
> > and a disassembled DSDT.
> 
> Thanks very much!
> 
> "ACPI: EC: Look up EC in DSDT" appears in the working log, but not
> in the broken one.  But I think we *do* find the EC in both cases,
> because we see "ACPI: EC: non-query interrupt received" even before
> acpi_ec_add() (which prints the "ACPI: EC: GPE = 0x1c, ...".  Maybe
> the logs were collected with different log levels?

Well, hm, actually no, the only difference is that the broken log was taken over
netconsole so the lines might appear in a different order. I'll capture that
log again on the weekend to see whether something is missing..
 
> I think Alexey is on the right track with the PCI resource allocation
> failure.

Then it should be the SMBus controller, PCI id 00:1f:3, which is having problems
registering its io ports region 4, AFAICT.

> On your working kernel, can you collect this:
> 
>   lspci -vv > lspci
>   cat /proc/ioports > ioports
>   cat /proc/iomem > iomem
>   grep . /sys/devices/pnp*/*/resources > pnp
>   tar -jcf resources.tar.bz2 lspci ioports iomem pnp

attached.

-- 
Regards/Gruﬂ,
    Boris.

--sm4nu43k4a2Rpi4c
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="resources.tar.bz2"
Content-Transfer-Encoding: base64

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

--sm4nu43k4a2Rpi4c--
