Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYABCG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYABCG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYABCGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:06:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:9878 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYABCGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:06:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,231,1196668800"; 
   d="scan'208";a="266857426"
Subject: Re: [PATCH linux-acpi] Correct wakeup set error and append a new
	column PCI ID
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <20080101232011.GA2545@ucw.cz>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>
	 <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
	 <20080101232011.GA2545@ucw.cz>
Content-Type: text/plain
Organization: Intel
Date: Wed, 02 Jan 2008 10:03:59 +0800
Message-Id: <1199239440.3806.18.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-02 at 00:20 +0100, Pavel Machek wrote:
> Hi!
> 
> > /proc/acpi/wakeup is also case-sensitive, case-insensitive is better.
> 
> Why?
A user uses device bus id like 'C093' to enable or disable wakeup of the
device, for example

echo "C093" > /proc/acpi/wakeup

but i think "c093" should also be ok. i.e.

"echo 'c093' > /proc/acpi/wakeup" should have the same result as "echo
'C093' > /proc/acpi/wakeup".

That is to say, it should be case-insensitive.
> 
> > In addtion, this patch appends a new column 'PCI ID' to /proc/acpi/wakeup
> > , the user can use it to get the corresponding device name very
> > conveniently because PCI ID is a unique identifier and platform-independent.
> 
> Userland interface change...?
Not at all, i didn't find any userland application
assumes /proc/acpi/wakeup must be that kind of format.

In fact, /proc output is always changing. :-)
> 
> Maybe this file should be left for compatibility and we should present
> something reasonable in /sys? Can't you already get PCI ID from sysfs
> node?
PCI ID can be gotten from sysfs, but it is a unique identifier for a
device, a user can get device name from /usr/share/hwdata/pci.ids in any
dstribution by PCI ID, he/she is unnecessary to use bus number to get
device name, bus number is platform-specific, but PCI ID is
platform-independent.

> 								Pavel
> 
> > [root@localhost ~]# cat /proc/acpi/wakeup
> > Device  S-state   Status   Sysfs node
> > C093      S5     disabled  pci:0000:00:1e.0
> > C0E8      S3     disabled  pci:0000:00:1d.0
> > C0EF      S3     disabled  pci:0000:00:1d.1
> > C0F0      S3     disabled  pci:0000:00:1d.2
> > C0F1      S3     disabled  pci:0000:00:1d.3
> > C0F2      S3     disabled  pci:0000:00:1d.7
> > C0F9      S0     disabled  pci:0000:00:1c.0
> > C21D      S0     disabled  pci:0000:08:00.0
> > C109      S5     disabled  pci:0000:00:1c.1
> > C228      S5     disabled  pci:0000:10:00.0
> > C10F      S5     disabled  pci:0000:00:1c.3
> > C229      S5     disabled
> > [root@localhost ~]#
> > 
> > After applying this patch, the output is:
> > 
> > [root@localhost ~]# cat /proc/acpi/wakeup
> > Device  S-state   Status   Sysfs node           PCI ID
> > C093      S5     disabled  pci:0000:00:1e.0     0x2448
> > C0E8      S3     disabled  pci:0000:00:1d.0     0x27c8
> > C0EF      S3     disabled  pci:0000:00:1d.1     0x27c9
> > C0F0      S3     disabled  pci:0000:00:1d.2     0x27ca
> > C0F1      S3     disabled  pci:0000:00:1d.3     0x27cb
> > C0F2      S3     disabled  pci:0000:00:1d.7     0x27cc
> > C0F9      S0     disabled  pci:0000:00:1c.0     0x27d0
> > C21D      S0     disabled  pci:0000:08:00.0     0x16fd
> > C109      S5     disabled  pci:0000:00:1c.1     0x27d2
> > C228      S5     disabled  pci:0000:10:00.0     0x4222
> > C10F      S5     disabled  pci:0000:00:1c.3     0x27d6
> > C229      S5     disabled
> 

