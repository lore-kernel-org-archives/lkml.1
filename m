Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbYAAXVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbYAAXVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYAAXVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:21:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:56523 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbYAAXVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:21:21 -0500
Date: Wed, 2 Jan 2008 00:20:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Yi Yang <yi.y.yang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
Subject: Re: [PATCH linux-acpi] Correct wakeup set error and append a new column PCI ID
Message-ID: <20080101232011.GA2545@ucw.cz>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com> <1198744900.3640.4.camel@yangyi-dev.bj.intel.com> <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> /proc/acpi/wakeup is also case-sensitive, case-insensitive is better.

Why?

> In addtion, this patch appends a new column 'PCI ID' to /proc/acpi/wakeup
> , the user can use it to get the corresponding device name very
> conveniently because PCI ID is a unique identifier and platform-independent.

Userland interface change...?

Maybe this file should be left for compatibility and we should present
something reasonable in /sys? Can't you already get PCI ID from sysfs
node?
								Pavel

> [root@localhost ~]# cat /proc/acpi/wakeup
> Device  S-state   Status   Sysfs node
> C093      S5     disabled  pci:0000:00:1e.0
> C0E8      S3     disabled  pci:0000:00:1d.0
> C0EF      S3     disabled  pci:0000:00:1d.1
> C0F0      S3     disabled  pci:0000:00:1d.2
> C0F1      S3     disabled  pci:0000:00:1d.3
> C0F2      S3     disabled  pci:0000:00:1d.7
> C0F9      S0     disabled  pci:0000:00:1c.0
> C21D      S0     disabled  pci:0000:08:00.0
> C109      S5     disabled  pci:0000:00:1c.1
> C228      S5     disabled  pci:0000:10:00.0
> C10F      S5     disabled  pci:0000:00:1c.3
> C229      S5     disabled
> [root@localhost ~]#
> 
> After applying this patch, the output is:
> 
> [root@localhost ~]# cat /proc/acpi/wakeup
> Device  S-state   Status   Sysfs node           PCI ID
> C093      S5     disabled  pci:0000:00:1e.0     0x2448
> C0E8      S3     disabled  pci:0000:00:1d.0     0x27c8
> C0EF      S3     disabled  pci:0000:00:1d.1     0x27c9
> C0F0      S3     disabled  pci:0000:00:1d.2     0x27ca
> C0F1      S3     disabled  pci:0000:00:1d.3     0x27cb
> C0F2      S3     disabled  pci:0000:00:1d.7     0x27cc
> C0F9      S0     disabled  pci:0000:00:1c.0     0x27d0
> C21D      S0     disabled  pci:0000:08:00.0     0x16fd
> C109      S5     disabled  pci:0000:00:1c.1     0x27d2
> C228      S5     disabled  pci:0000:10:00.0     0x4222
> C10F      S5     disabled  pci:0000:00:1c.3     0x27d6
> C229      S5     disabled

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
