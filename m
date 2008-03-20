Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYCTNZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYCTNZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 09:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYCTNZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 09:25:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:60300 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYCTNZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 09:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WOa98s1nxn0kh/L0TBDYgkkHkfetE6cswdl1yPfneol8xng08UxbLMDmNFo+/UYxiSyp3QnJvKS6b0YAIZ6PSd9ufPy9N+wvAeJvjfweiGRuZmR0AxoPBatCVacwRJSwuUT81kdI/PJjhQFmh22OIbgqgLS3h8EmtXpIOzY+yrk=
Message-ID: <91b13c310803200622k6a302851nc97774615f2ef3ee@mail.gmail.com>
Date: Thu, 20 Mar 2008 21:22:29 +0800
From: "rae l" <crquan@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>, "David Miller" <davem@davemloft.net>,
       "Christoph Hellwig" <hch@lst.de>, "Dominik Brodowski" <linux@brodo.de>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Nick Piggin" <npiggin@suse.de>, "Len Brown" <len.brown@intel.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: many items in Documentation/feature-removal-schedule.txt have expired, please update
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that many feature removal schedule marked in this file have
expired, so please update information:
1. if the feature has been removed, please remove it from this file;
2. if it does not, please update the schedule date;

---

The following is a list of files and features that are going to be
removed in the kernel source tree.  Every entry should contain what
exactly is going away, why it is happening, and who is going to be doing
the work.  When the feature is removed from the kernel, it should also
be removed from this file.

---------------------------

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

---------------------------

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

What:   eepro100 network driver
When:   January 2007
Why:    replaced by the e100 driver
Who:    Adrian Bunk <bunk@stusta.de>

---------------------------

What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
	(temporary transition config option provided until then)
	The transition config option will also be removed at the same time.
When:	before 2.6.19
Why:	Unused symbols are both increasing the size of the kernel binary
	and are often a sign of "wrong API"
Who:	Arjan van de Ven <arjan@linux.intel.com>

---------------------------

What:	vm_ops.nopage
When:	Soon, provided in-kernel callers have been converted
Why:	This interface is replaced by vm_ops.fault, but it has been around
	forever, is used by a lot of drivers, and doesn't cost much to
	maintain.
Who:	Nick Piggin <npiggin@suse.de>

---------------------------

What:	/proc/acpi/event
When:	February 2008
Why:	/proc/acpi/event has been replaced by events via the input layer
	and netlink since 2.6.23.
Who:	Len Brown <len.brown@intel.com>

---------------------------

What:   sk98lin network driver
When:   Feburary 2008
Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
	replaced by the skge driver.
Who:    Stephen Hemminger <shemminger@linux-foundation.org>

--
Denis Cheng
