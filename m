Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXIZXCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXIZXCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbXIZXB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:01:57 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57391 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbXIZXB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:01:57 -0400
Date: Wed, 26 Sep 2007 17:01:34 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
In-reply-to: <fa.G9DPndNUxuPi5LrUTOL4uPFshnc@ifi.uio.no>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       Matthew Wilcox <matthew@wil.cx>, Shaohua Li <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <46FAE4CE.10801@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no>
 <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no>
 <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no>
 <fa.0Edi0qLTdvqVnuoDAebaTVz1jEM@ifi.uio.no>
 <fa.sq+NimBnzGB2syLmvcIGOvDkixI@ifi.uio.no>
 <fa.G9DPndNUxuPi5LrUTOL4uPFshnc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Mon, 2007-09-17 at 14:22 +0400, Ivan Kokshaysky wrote:
>> On Sun, Sep 16, 2007 at 10:01:52PM +0200, Benjamin Herrenschmidt wrote:
>>> Agreed. I have a similar problem on ppc where it's common to have things
>>> like the main PIC on a PCI device. Note that another problem is (or at
>>> least was, i haven't checked recently) the P2P bridge scanning code
>>> that, in a similar way, can block the path to all devices below it. I
>>> -do- have a case for example with Apple Xserve G4's where the main Apple
>>> IO ASIC, which is a PCI device containing the PIC, the power management
>>> controller, and various low level system control IOs is behind a pair of
>>> P2P bridges.
>> I think the P2P probing code is pretty safe now - there are read-only
>> accesses to the bridge config, unless you request to reassign the bus
>> numbers. Though it won't be safe anymore with the patch in question.
> 
> In which case I will need to NAK the patch... Note that those Xserve
> G4's still have the subtle issue that they -also- reassign bus
> numbers :-) But that's going away the day I finally enable domains
> support for ppc32 (it's been off for now due to problems with X)

How is this a change in behavior as far as this device is concerned? If 
we are doing BAR sizing and moving the base address around, it's going 
to cause problems if you try to access the device during this time 
whether we disable decode or not.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

