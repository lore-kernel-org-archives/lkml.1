Return-Path: <linux-kernel-owner+w=401wt.eu-S1764635AbXJRNbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764635AbXJRNbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757776AbXJRNb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:31:29 -0400
Received: from rtr.ca ([76.10.145.34]:3417 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613AbXJRNb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:31:28 -0400
Message-ID: <4717602E.2080903@rtr.ca>
Date: Thu, 18 Oct 2007 09:31:26 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: kristen.c.accardi@intel.com, greg@kroah.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 1/3] pciehp: hotplug: deal with pre-inserted
 ExpressCards
References: <4716CB9D.6080503@rtr.ca> <4716D3C0.20808@rtr.ca> <47174069.9000108@jp.fujitsu.com>
In-Reply-To: <47174069.9000108@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige wrote:
> Hi Mark,
> 
> I still don't understand what the problems is very much.

If a PCIe ExpressCard34 is inserted into the slot *before*
I modprobe pciehp (with pciehp_force=1), then the card is not
detected nor enabled.  The patch provided here fixes that.

> Could you give me answers against the following questions?
> 
>  (1) Did you try "echo 1 > /sys/bus/pci/slots/XXX/power"?
>      (XXX is the slot number to which your card had been inserted)
>  (2) If the answer against (1) is yes, did "echo 1 > ..." work?


After 1. inserting the card, and then 2. modprobing pciehp,
the value of /sys/bus/pci/slots/XXX/power is already "1".

But, yes, doing "echo 1" into it does trigger card detection
and things work afterwards.  This doesn't really help,
because it doesn't happen automatically, unless the kernel patch
is applied.

>  (6) I think your slot is surprise removable. Is it correct?

Yes, it's an externally accessible ExpressCard slot on a notebook,
which is intended to be fully hotpluggable by surprise or otherwise.

Cheers


