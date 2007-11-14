Return-Path: <linux-kernel-owner+w=401wt.eu-S1762690AbXKNRyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690AbXKNRyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762078AbXKNRxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:53:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52249 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762034AbXKNRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:53:39 -0500
Date: Wed, 14 Nov 2007 09:53:17 -0800
From: Greg KH <greg@kroah.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Alex Chiang <achiang@hp.com>, gregkh@suse.de, lenb@kernel.org,
       matthew@wil.cx, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114175317.GB14994@kroah.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113202632.GA3227@kroah.com> <20071113145936.7e1c58fb.kristen.c.accardi@intel.com> <200711141037.09228.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711141037.09228.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 10:37:08AM -0700, Bjorn Helgaas wrote:
> On Tuesday 13 November 2007 03:59:36 pm Kristen Carlson Accardi wrote:
> > On Tue, 13 Nov 2007 12:26:32 -0800 Greg KH <greg@kroah.com> wrote:
> > > And isn't there some other tool that dumps the raw ACPI tables?  I
> > > thought the acpi developers used it all the time when debugging things
> > > with users.
> > 
> > There are - people should take a look at the Intel Linux Firmware Kit
> > for an example of how to parse ACPI tables in userspace - the code
> > is also GPL'd, so you are free to use it in another GPL application.
> > 
> > http://www.linuxfirmwarekit.org/download.php#source
> > 
> > In many DSDTs I've seen, _SUN is hardcoded anyway and can be found
> > by reading the DSDT from userspace.  This is what the firmwarekit
> > does to check for duplicate _SUN in one of it's tests.
> 
> I see three relevant things in the firmware kit:
> 
>   1) ExecuteAmlMethod() in amlpoke/amlpoke.c.  This uses
>      /proc/acpi/hotkey/event_config to cause the kernel to
>      execute an AML method.  This looks similar to what dev_acpi
>      does and is unsafe for the same reasons (the method may have
>      side effects that interfere with kernel drivers).  The kernel
>      support for this was removed in 2.6.21:
> 
>        http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5ee6edbcde4d3b14e4e03d4b331df1099a34aa8d
> 
>   2) execute_aml_method() in acpitable.c.  Similar to above.
> 
>   3) parse_SUN_name() in SUN/SUN.c.  This uses acpidump, acpixtract,
>      and iasl -d to disassemble the DSDT and SSDTs, then looks for
>      things like "Name (_SUN, 0x0000012C)".  That works well if _SUN
>      merely returns a constant, and many DSDTs do that.
> 
>      But _SUN can be implemented as a control method, and then we have
>      a problem because we can't determine the _SUN value by inspecting
>      the DSDT.  We have to evaluate the method, and that may require
>      operation regions, semaphores, etc., so it can only be done in the
>      kernel.
> 
> So I agree that the firmware kit has a clever hack that works on much
> existing x86 firmware, and it sounds like Tivoli might even rely on
> it.  But I don't feel good about it, and it could easily break when
> some BIOS writer needs to make _SUN slightly more complicated.

Do you know of such BIOSes out there that do this?  Will the above
scheme not work for the ia64 boxes that you know of that are out in the
world today?

thanks,

greg k-h
