Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbXI0COS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbXI0COS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 22:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXI0COJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 22:14:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40266 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbXI0COI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 22:14:08 -0400
Date: Wed, 26 Sep 2007 20:14:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070927021403.GS3899@parisc-linux.org>
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no> <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no> <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <fa.0Edi0qLTdvqVnuoDAebaTVz1jEM@ifi.uio.no> <fa.sq+NimBnzGB2syLmvcIGOvDkixI@ifi.uio.no> <fa.G9DPndNUxuPi5LrUTOL4uPFshnc@ifi.uio.no> <46FAE4CE.10801@shaw.ca> <1190853633.11034.6.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190853633.11034.6.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 10:40:33AM +1000, Benjamin Herrenschmidt wrote:
> 
> > How is this a change in behavior as far as this device is concerned? If 
> > we are doing BAR sizing and moving the base address around, it's going 
> > to cause problems if you try to access the device during this time 
> > whether we disable decode or not.
> 
> True. The window is smaller tho if the upper bridge decode hasn't been
> disabled. I suppose I'll have to find a way to "pin" those devices and
> generate the BAR info from the firmware data.

The upper bridge decode only gets disabled while we size the upper
bridge's BARs.  Then we reenable it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
