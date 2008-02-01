Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbYBABjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbYBABjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYBABiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:38:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:16092 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbYBABix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:38:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jMDyTbGt5fZ1lHla11A59UFW9gLYD0I267n9Vp2D9Mqv9f/wDCSCWAfXV30OysTE1c43MuUWqJYImJHh7G0MIhgmnmbqbBHaQ/zFnKLzYjd58WGM+0iVc9gTh4t08F/kWJ9Xp8y4Tqua77eHk+z8LFdlMJqK46KqCwpjT5iXBUQ=
Subject: Feature Removals for 2.6.25
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 17:38:42 -0800
Message-Id: <1201829922.23523.68.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following are entries in feature-removal-schedule.txt that have
come due.  Please change the subject when replying to specific items.

Where I've gotten responses from the named person in the file, I've
included their comment.

---------------------------

What:	MXSER
When:	December 2007
Why:	Old mxser driver is obsoleted by the mxser_new. Give it some time yet
	and remove it.
Who:	Jiri Slaby <jirislaby@gmail.com>

Jiri says probably not for 2.6.25, likely 2.6.26
Patch in mm:
http://userweb.kernel.org/~akpm/mmotm/broken-out/char-mxser-remove-it.patch
---------------------------

Ping?
What:	dev->power.power_state
When:	July 2007
Why:	Broken design for runtime control over driver power states, confusing
	driver-internal runtime power management with:  mechanisms to support
	system-wide sleep state transitions; event codes that distinguish
	different phases of swsusp "sleep" transitions; and userspace policy
	inputs.  This framework was never widely used, and most attempts to
	use it were broken.  Drivers should instead be exposing domain-specific
	interfaces either to kernel or to userspace.
Who:	Pavel Machek <pavel@suse.cz>

---------------------------

What:	old NCR53C9x driver
When:	October 2007
Why:	Replaced by the much better esp_scsi driver.  Actual low-level
	driver can be ported over almost trivially.
Who:	David Miller <davem@davemloft.net>
	Christoph Hellwig <hch@lst.de>

DaveM: Likely one more release with this, perhaps delete 2.6.26
---------------------------
Ping?
What:	PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
When:	November 2005
Files:	drivers/pcmcia/: pcmcia_ioctl.c
Why:	With the 16-bit PCMCIA subsystem now behaving (almost) like a
	normal hotpluggable bus, and with it using the default kernel
	infrastructure (hotplug, driver core, sysfs) keeping the PCMCIA
	control ioctl needed by cardmgr and cardctl from pcmcia-cs is
	unnecessary, and makes further cleanups and integration of the
	PCMCIA subsystem into the Linux kernel device driver model more
	difficult. The features provided by cardmgr and cardctl are either
	handled by the kernel itself now or are available in the new
	pcmciautils package available at
	http://kernel.org/pub/linux/utils/kernel/pcmcia/
Who:	Dominik Brodowski <linux@brodo.de>

---------------------------

What:  a.out interpreter support for ELF executables
When:  2.6.25
Files: fs/binfmt_elf.c
Why:   Using a.out interpreters for ELF executables was a feature for
       transition from a.out to ELF. But now it is unlikely to be still
       needed anymore and removing it would simplify the hairy ELF
       loader code.
Who:   Andi Kleen <ak@suse.de>

Patch in mm.
---------------------------
Ping?
What:	remove EXPORT_SYMBOL(kernel_thread)
When:	August 2006
Files:	arch/*/kernel/*_ksyms.c
Check:	kernel_thread
Why:	kernel_thread is a low-level implementation detail.  Drivers should
        use the <linux/kthread.h> API instead which shields them from
	implementation details and provides a higherlevel interface that
	prevents bugs and code duplication
Who:	Christoph Hellwig <hch@lst.de>

---------------------------

What:	CONFIG_FORCED_INLINING
When:	June 2006
Why:	Config option is there to see if gcc is good enough. (in january
        2006). If it is, the behavior should just be the default. If it's not,
	the option should just go away entirely.
Who:    Arjan van de Ven

Patch submitted to Arjan, maybe 2.6.25?
---------------------------
Ping?
What:   eepro100 network driver
When:   January 2007
Why:    replaced by the e100 driver
Who:    Adrian Bunk <bunk@stusta.de>

---------------------------
Ping? Possibly remove this from feature-removal-schedule?

What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
	(temporary transition config option provided until then)
	The transition config option will also be removed at the same time.
When:	before 2.6.19
Why:	Unused symbols are both increasing the size of the kernel binary
	and are often a sign of "wrong API"
Who:	Arjan van de Ven <arjan@linux.intel.com>

---------------------------
Ping?
What:	USB driver API moves to EXPORT_SYMBOL_GPL
When:	February 2008
Files:	include/linux/usb.h, drivers/usb/core/driver.c
Why:	The USB subsystem has changed a lot over time, and it has been
	possible to create userspace USB drivers using usbfs/libusb/gadgetfs
	that operate as fast as the USB bus allows.  Because of this, the USB
	subsystem will not be allowing closed source kernel drivers to
	register with it, after this grace period is over.  If anyone needs
	any help in converting their closed source drivers over to use the
	userspace filesystems, please contact the
	linux-usb-devel@lists.sourceforge.net mailing list, and the developers
	there will be glad to help you out.
Who:	Greg Kroah-Hartman <gregkh@suse.de>

---------------------------
Ping?
What:	vm_ops.nopage
When:	Soon, provided in-kernel callers have been converted
Why:	This interface is replaced by vm_ops.fault, but it has been around
	forever, is used by a lot of drivers, and doesn't cost much to
	maintain.
Who:	Nick Piggin <npiggin@suse.de>

---------------------------
Should this be removed?
What:	/proc/acpi/button
When:	August 2007
Why:	/proc/acpi/button has been replaced by events to the input layer
	since 2.6.20.
Who:	Len Brown <len.brown@intel.com>

LenB: we try to remove them, but every time we do, people scream.
---------------------------
Should this be removed?
What:	/proc/acpi/event
When:	February 2008
Why:	/proc/acpi/event has been replaced by events via the input layer
	and netlink since 2.6.23.
Who:	Len Brown <len.brown@intel.com>

LenB: we try to remove them, but every time we do, people scream.
---------------------------

What:	'time' kernel boot parameter
When:	January 2008
Why:	replaced by 'printk.time=<value>' so that printk timestamps can be
	enabled or disabled as needed
Who:	Randy Dunlap <randy.dunlap@oracle.com>

RDunlap: Adrian Bunk sent a patch for it.  I acked it.
Andrew merged it into -mm according to a commits email.
---------------------------
Ping, although Adrian is pretty good about this.
What:  drivers depending on OSS_OBSOLETE
When:  options in 2.6.23, code in 2.6.25
Why:   obsolete OSS drivers
Who:   Adrian Bunk <bunk@stusta.de>

---------------------------
Ping?
What:   sk98lin network driver
When:   Feburary 2008
Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
	replaced by the skge driver. 
Who:    Stephen Hemminger <shemminger@linux-foundation.org>

Cheers,

Harve

