Return-Path: <linux-kernel-owner+w=401wt.eu-S1764878AbXJRDJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764878AbXJRDJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbXJRDJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:09:47 -0400
Received: from rtr.ca ([76.10.145.34]:3506 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678AbXJRDJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:09:46 -0400
Message-ID: <4716CE79.7040201@rtr.ca>
Date: Wed, 17 Oct 2007 23:09:45 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [PATCH 0/3] Fix two PEIe hotplug issues
References: <4716CB9D.6080503@rtr.ca>
In-Reply-To: <4716CB9D.6080503@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
> (and others?) in conjunction with the modparam of pciehp_force=1.


To make things simpler for distro people, I'm contemplating another patch
in this series, to allow something like:  pciehp_force=2

This would then *try* the ACPI BIOS calls, and only fall back to pcie_force=1
if the BIOS support fails.  This would be an ideal default for most desktop/notebook
distros to consider using.

Without this, they don't have any good choice:  use the defaults, and things fail
on the most popular brand of machines in the marketplace.  Use pciehp_force=1,
and they may break (?) on other brands.

So a hybrid of the two seems best.  Pity it couldn't be the default behaviour, though.
Or could it?  We're early enough in the 2.6.24 cycle for it..

Opinions?
