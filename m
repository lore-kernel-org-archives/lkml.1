Return-Path: <linux-kernel-owner+w=401wt.eu-S1763199AbXINDeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763199AbXINDeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 23:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbXINDeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 23:34:11 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52512 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbXINDeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 23:34:10 -0400
Date: Thu, 13 Sep 2007 21:32:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
In-reply-to: <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <46EA00DA.6010704@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no>
 <fa.o5cJ0O7pLVWRzUiVPDEZL6nKqA8@ifi.uio.no>
 <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no>
 <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no>
 <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no>
 <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Thu, Sep 13, 2007 at 02:53:13AM -0700, Greg KH wrote:
>> On Thu, Sep 13, 2007 at 01:55:36AM -0600, Matthew Wilcox wrote:
>>> Unfortunately if this patch does cause any machine to break, these will
>>> be machines that worked fine up until this point, so that would be a
>>> regression, which is worse.  Life sucks.
>> If, after a while, you think the change should go into the -stable tree,
>> I have no objection.
> 
> I think it shouldn't - this change will almost certainly cause a regression.
> There is a lot of system devices besides the host bridges that shouldn't be
> disabled during BAR probe, like interrupt controllers, power management
> controllers and so on.
> 
> We need a more sophisticated fix - I'm thinking of introducing "probe" field
> in struct pci_dev which can be set by "early" quirk routines.

Disabling the BAR decoding does not mean disabling the device (aside 
from the one  group of host bridge that apparently disables CPU to RAM 
access, whose designers were apparently on crack when they read the PCI 
spec and which is why we don't disable the decode on host bridges). 
There really is no other sane way to do it.

If we do encounter other devices that choke on having the BAR disabled 
during probing then we can add additional quirk logic, but we haven't 
run into anything like that yet.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

