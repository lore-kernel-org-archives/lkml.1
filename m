Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYBFT4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYBFT4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbYBFT4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:56:48 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:64026 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYBFT4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:56:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cIUvREZO97YzWkopCLPiADGM++Itnw+hV8zj4L5EBbtsYSZyBC9vYvGNWFYiMbyRFEIKfQASdcygWmtdJsDS9ZqN68P19nvg1gmsRCz3Z3n8U3V6CAk28iq2V3YAt/4ma73NN2P0lwEYa3M2sN7Uq+DfIepEYLXZZFzUdyaxXgI=
Subject: Re: feature-removal-schedule.txt is getting out of date again
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <200802062054.59755.bzolnier@gmail.com>
References: <alpine.LFD.1.00.0802060419140.17178@localhost.localdomain>
	 <200802062054.59755.bzolnier@gmail.com>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 11:56:43 -0800
Message-Id: <1202327803.5820.32.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-06 at 20:54 +0100, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Wednesday 06 February 2008, Robert P. J. Day wrote:
> > 
> >   yes, i realize i'm sounding like a broken record but, once again,
> > Documentation/feature-removal-schedule.txt is slipping out of date WRT
> > items that are now slightly, if not noticeably, behind schedule for
> > removal.

A quick summary of what I've been tracking, some have already gone in,
but I'll wait for rc1 to do a pass over all this and send out a summary.

What: CONFIG_FORCED INLINING:
-removal patch being tested in x86.git, upstream unlikely for 2.6.25,
not a big deal to wait for 2.6.26


What: old NCR53C9x driver
> When: October 2007
> Why:  Replaced by the much better esp_scsi driver.  Actual low-level
>       driver can be ported over almost trivially.
> Who:  David Miller <davem@davemloft.net>
>       Christoph Hellwig <hch@lst.de>
> 
> DaveM: Likely one more release with this, perhaps delete 2.6.26
> ---------------------------
This has been done and is currently in scsi-misc awaiting for a pull.


> What: vm_ops.nopage
> When: Soon, provided in-kernel callers have been converted
> Why:  This interface is replaced by vm_ops.fault, but it has been
around
>       forever, is used by a lot of drivers, and doesn't cost much to
>       maintain.
> Who:  Nick Piggin <npiggin@suse.de>

Well the in-kernel callers have not all been converted yet. I have
actually done the work, but it needs testing and merging by maintainers.
Getting it done during this merge window would be nice, I'm going to
try to make that happen after I get back from LCA. Otherwise probably
2.6.26.

> Ping?
> What:   sk98lin network driver
> When:   Feburary 2008
> Why:    In kernel tree version of driver is unmaintained. Sk98lin
driver
>       replaced by the skge driver. 
> Who:    Stephen Hemminger <shemminger@linux-foundation.org>
> 

Stephen Hemminger sent a removal patch to Jeff, it probably was too big
for the mailing list.

Ping?
> What: USB driver API moves to EXPORT_SYMBOL_GPL
> When: February 2008
> Files:        include/linux/usb.h, drivers/usb/core/driver.c
> Why:  The USB subsystem has changed a lot over time, and it has been
>       possible to create userspace USB drivers using
usbfs/libusb/gadgetfs
>       that operate as fast as the USB bus allows.  Because of this,
the USB
>       subsystem will not be allowing closed source kernel drivers to
>       register with it, after this grace period is over.  If anyone
needs
>       any help in converting their closed source drivers over to use
the
>       userspace filesystems, please contact the
>       linux-usb-devel@lists.sourceforge.net mailing list, and the
developers
>       there will be glad to help you out.
> Who:  Greg Kroah-Hartman <gregkh@suse.de>

GregKH: This is queued up in my tree to go to Linus, see my previous
post on
lkml and the linux-usb mailing list about this topic.

What: dev->power.power_state
> When: July 2007
> Why:  Broken design for runtime control over driver power states,
confusing
>       driver-internal runtime power management with:  mechanisms to
support
>       system-wide sleep state transitions; event codes that
distinguish
>       different phases of swsusp "sleep" transitions; and userspace
policy
>       inputs.  This framework was never widely used, and most attempts
to
>       use it were broken.  Drivers should instead be exposing
domain-specific
>       interfaces either to kernel or to userspace.
> Who:  Pavel Machek <pavel@suse.cz>

Still some users in-tree, some discussion happening on how to get this
finished.


Cheers,

Harvey

