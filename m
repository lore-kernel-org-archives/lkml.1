Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab0BKV4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:56:34 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50975 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab0BKV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:56:32 -0500
Date: Thu, 11 Feb 2010 13:56:04 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-pm@lists.linux-foundation.org,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME
	wake-up (rev. 7)
Message-ID: <20100211215604.GA10298@us.ibm.com>
References: <201001101431.38630.rjw@sisk.pl> <201002111427.17275.rjw@sisk.pl> <20100211182910.GA9766@us.ibm.com> <201002112132.02255.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002112132.02255.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 09:32:02PM +0100, Rafael J. Wysocki wrote:
> On Thursday 11 February 2010, Gary Hade wrote:
> > On Thu, Feb 11, 2010 at 02:27:17PM +0100, Rafael J. Wysocki wrote:
> > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > On Thu, Feb 11, 2010 at 01:56:54AM +0100, Rafael J. Wysocki wrote:
> > > > > On Thursday 11 February 2010, Rafael J. Wysocki wrote:
> > > > > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > > > > On Wed, Feb 10, 2010 at 11:58:00PM +0100, Rafael J. Wysocki wrote:
> > > > > > > > On Wednesday 10 February 2010, Gary Hade wrote:
> > > > > > ...
> > > > > > > > > Yes, 6/9 also appeared to be the most likely suspect to me and
> > > > > > > > > I was already doing what you asked except in the opposite order.
> > > > > > > > > With 1/9 through 6/9 both the hot-add and hot-remove issues still
> > > > > > > > > reproduced.  After removing 6/9 both issues disappeared.
> > > > > > > > 
> > > > > > > > Thanks for verifying, I've already started to look for bugs in it.
> > > > > > > 
> > > > > > > Thanks!
> > > > > > > 
> > > > > > > > 
> > > > > > > > What's your kernel command line, BTW?
> > > > > > > 
> > > > > > > root=/dev/disk/by-id/scsi-35000c5000036ffcb-part7 ip=9.47.66.9:9.47.67.50:9.47.66.1:255.255.254.0 resume=/dev/disk/by-id/scsi-35000c50000370247-part3 crashkernel=256M-:128M console=tty0 console=ttyS0,115200 pci=use_crs pci=norom
> > > > > > 
> > > > > > Thanks.  We found a bug in the patch, but it would require you to use a
> > > > > > specific command line switch to trigger, which you don't use.
> > > > > > 
> > > > > > I'll let you know if I have anything to test.
> > > > > 
> > > > > OK, please try the patch below on top of [1-6/9].
> > > > 
> > > > Sorry, it didn't help.  The hot-add and hot-remove behaviors
> > > > still look the same.
> > > 
> > > Thanks for testing.
> > > 
> > > Well, this time I found another real bug, which is that we should add
> > > gpe_block->block_base_number to the GPE index within the block in order to
> > > compute the GPE number.  If there are GPE devices other than the FADT ones in
> > > your system, that may explain the symptoms.
> > > 
> > > Please try the patch below (on top of [1-6/9]).  In case it doesn't help, please
> > > look for "Failed to ebable GPE" messages in dmesg and let me know if there are
> > > any.
> > 
> > That one worked!  It corrected both the blinking amber LED
> > after hot-remove and acpiphp's failure to see the hot-add event.
> 
> Great!
> 
> > Now when you have patch(es) ready for Jesse's linux-next branch
> 
> Well, not quite.  I had to rework them in the meantime. ;-)
> 
> > I can get back to my original mission of checking out Bjorn's
> > _CRS enablement changes.
> 
> May I still ask you to test something?

Oh, I guess so. :)

> 
> In case I can, please try the appended patch on top of [1-3/6].  It is a
> replacement for [4-6/9] with the last fix included.

I just tried it and it seemed to work fine.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

