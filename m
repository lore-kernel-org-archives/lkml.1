Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbXIPXiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbXIPXiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 19:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbXIPXiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 19:38:14 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:62429 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbXIPXiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 19:38:13 -0400
Date: Sun, 16 Sep 2007 17:37:29 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
In-reply-to: <1189973176.6403.20.camel@localhost.localdomain>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       Matthew Wilcox <matthew@wil.cx>, Shaohua Li <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <46EDBE39.4090704@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no>
 <fa.o5cJ0O7pLVWRzUiVPDEZL6nKqA8@ifi.uio.no>
 <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no>
 <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no>
 <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no>
 <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca>
 <1189973176.6403.20.camel@localhost.localdomain>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Thu, 2007-09-13 at 21:32 -0600, Robert Hancock wrote:
>> If we do encounter other devices that choke on having the BAR
>> disabled 
>> during probing then we can add additional quirk logic, but we haven't 
>> run into anything like that yet.
> 
> Well... if the device needs to be accessed to service an interrupt then
> you do have a problem. For example... the PIC :-)
> 
> Problem is.. it's not practical nor really feasible generally to have
> IRQs off on all CPUs during PCI probing neither... Unless we define that
> the initial boot time probing is "special", and the first pass that
> actually probes devices (and doesn't muck around with the sysfs
> hierarchy etc...) can be run in a special context with all interrupt
> servicing disabled on the PIC, though that will require some arch
> support.
> 
> Ben.

We would already have this problem, though. If it causes problems to 
disable decode on the BAR because we try to access it in interrupt 
context, we would already have problems because we move the thing to 
0xFFFFFFFF during probing anyway..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

