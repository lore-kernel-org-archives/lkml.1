Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbXAXWHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbXAXWHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXAXWHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:07:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:43203 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbXAXWHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:07:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,233,1167638400"; 
   d="scan'208"; a="39366721:sNHT19656837"
Message-ID: <45B7D88F.30703@intel.com>
Date: Wed, 24 Jan 2007 14:07:11 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Roger Heflin <rheflin@atipa.com>
CC: NetDev <netdev@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nvidia MCP55 Machine reboots on ixgb driver load
References: <45B7CA3D.9020601@atipa.com>
In-Reply-To: <45B7CA3D.9020601@atipa.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jan 2007 22:07:12.0062 (UTC) FILETIME=[FF989DE0:01C74003]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[added netdev to CC]

Roger Heflin wrote:
> I have a machine (actually 2 machines) that upon loading
> the intel 10GBe driver (ixgb) the machine reboots, I am
> using a RHAS4.4 based distribution with Vanilla 2.6.19.2
> (the RHAS 4.4.03 kernel also reboots with the ixgb load),
> I don't see any messages on the machine before it reboots,
> loading the driver with debug does not appear to produce
> any extra messages.   The basic steps are the I load
> the driver, the machine locks up, and then in a second
> or 2 it starts to post.

some suggestions immediately come to mind:

* have you tried the latest driver from http://e1000.sf.net/ ?

* what happens when you unplug the card and modprobe the ixgb module?

* have you tried capturing a trace with netconsole or serial console? probing 
the ixgb driver produces at least 1 syslog line that should show up. If nothing 
shows up on serial or netconsole, the issue may be way outside the ixgb driver.

> I have tried the default ixgb driver in 2.6.19.2, and I
> have tried the open source intel driver on RH4.4, both cause
> the same reboot.    I also tried the linux firmware
> development kit, and booting fc6 causes the same reboot
> upon the network driver load.

just for completeness, which driver versions were this?

and when you say "booting fc6" I assume you mean that fc6 boots OK until you 
modprobe the ixgb driver?

> I have tried pci=nomsi

try compiling your kernel without MSI support alltogether. There have been 
serious issues found with MSI on certain configurations, and in your case this 
might be the cause. Allthough passing pci=nomsi should be the same as compiling 
it out, it can't hurt to try.

> Also note that the linux.nics@intel.com address is apparently
> unused and returns an email telling you to use a web page,
> and so far after using the web page I have not got any response
> indicating that anything got to anyone.

I've taken action to get that straightened out. You're always welcome to mail 
netdev, the e1000 devel list or even lkml which we will all pick up on.


I can't think of a specific reason for the issue right now, other than 
attempting to get a serial/netconsole attached and trying without any msi 
support in the kernel. Please give that a try and let us know.

Auke
