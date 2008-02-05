Return-Path: <linux-kernel-owner+w=401wt.eu-S1763031AbYBEXXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763031AbYBEXXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbYBEXXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:23:01 -0500
Received: from ns1.suse.de ([195.135.220.2]:36836 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbYBEXXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:23:00 -0500
Date: Tue, 5 Feb 2008 15:18:42 -0800
From: Greg KH <gregkh@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for review] ACPI: Create /sys/firmware/acpi/interrupts/
	counters
Message-ID: <20080205231842.GB8740@suse.de>
References: <200802050230.10873.lenb@kernel.org> <20080205221805.GC6950@suse.de> <200802051812.09228.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802051812.09228.lenb@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 06:12:09PM -0500, Len Brown wrote:
> On Tuesday 05 February 2008 17:18, Greg KH wrote:
> > On Tue, Feb 05, 2008 at 02:30:10AM -0500, Len Brown wrote:
> > > # cat /sys/firmware/acpi/interrupts/summary
> > > pm_timer     0
> > > glbl_lock    0
> > > power_btn    0
> > > sleep_btn    0
> > > rtc          0
> > > gpe00    0
> ...
> > > gpe1F    0
> > > gpe_hi    0
> > > gpe_total   63
> > > acpi_irq    63
> > 
> > Eeek!  Why?  What's wrong with individual files here?
> 
> My expectation is that this is a shell interface for debugging,
> not an API for programs.  ala /proc/interrupts.

Great, then use debugfs for it.  Please, don't put debug stuff like this
in sysfs, that's not what it is there for.  You can do whatever you want
in debugfs :)

> if we have 40 individual files, each with a number in it,
> it is less convenient to cat the file and paste the results
> into an email or bug report and have the receiver easily
> see what what count goes with what file -- or is there
> a version of cat that prints the file name before
> the contents of each file?
> 
> I've seen 
> more * | cat
> but one has to wonder why an interface would be built
> to make something so simple not be simple.

Use debugfs please.

> > What's to ensure 
> > that you aren't going to overflow your buffer?
> 
> Good question.  What's to ensure we don't overflow it
> when I print any other random string?
> Who allocates it and how big is it?

The core does, and if you are putting something too big in it, you are
using the sysfs interface wrong :)

Simple, one value per file is what sysfs is for.  Use debugfs for
debugging stuff.

thanks,

greg k-h
