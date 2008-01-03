Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYACCEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYACCEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 21:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYACCEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 21:04:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:24493 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbYACCEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 21:04:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,237,1196668800"; 
   d="scan'208";a="312865003"
Subject: Re: [PATCH linux-acpi] Correct wakeup set error and append a new
	column PCI ID
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <20080102160943.GA17187@ucw.cz>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>
	 <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
	 <20080101232011.GA2545@ucw.cz>
	 <1199239440.3806.18.camel@yangyi-dev.bj.intel.com>
	 <20080102160943.GA17187@ucw.cz>
Content-Type: text/plain
Organization: Intel
Date: Thu, 03 Jan 2008 10:02:00 +0800
Message-Id: <1199325720.3806.38.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-02 at 17:09 +0100, Pavel Machek wrote:
> On Wed 2008-01-02 10:03:59, Yi Yang wrote:
> > On Wed, 2008-01-02 at 00:20 +0100, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > /proc/acpi/wakeup is also case-sensitive, case-insensitive is better.
> > > 
> > > Why?
> > A user uses device bus id like 'C093' to enable or disable wakeup of the
> > device, for example
> > 
> > echo "C093" > /proc/acpi/wakeup
> > 
> > but i think "c093" should also be ok. i.e.
> 
> Why do you think so? Unix is generally case-sensitive. I see ascii
> text in .../wakeup. Maybe some bios vendor is crazy enough to have
> wakeup devices called 'wake', 'Wake', 'wAke', 'waKe', 'wakE'?
This is just for users' convenience, i believe you must think 0xff and
0xFF are the same.

> 
> > > Maybe this file should be left for compatibility and we should present
> > > something reasonable in /sys? Can't you already get PCI ID from sysfs
> > > node?
> > PCI ID can be gotten from sysfs, but it is a unique identifier for a
> > device, a user can get device name from /usr/share/hwdata/pci.ids in any
> > dstribution by PCI ID, he/she is unnecessary to use bus number to get
> > device name, bus number is platform-specific, but PCI ID is
> > platform-independent.
> 
> If the same info can be gotten from 'sysfs node' field, new field
> should not be added.
Assume you are a user of /proc/acpi/wakeup, when you
cat /proc/acpi/wakeup, you only get PCI bus id, then you need use PCI
bus id to get the device info, that is platform-specific, if you want to
use this PCI bus id to get the device info from another machines, that
is absolutely impossible, but it is ok if it is PCI ID.

Moreover, you can very easily get the device info
from /usr/share/hwdata/pci.ids.

grep <PCI ID> /usr/share/hwdata/pci.ids

That is more convenient than PCI bus id.

If we can provide PCI ID in /proc/acpi/wakeup, why we let users get that
from /sys/devices/pci...?

> 
> 

