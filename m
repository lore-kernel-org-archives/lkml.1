Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbXIZXF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbXIZXF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbXIZXFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:05:18 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:53568 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbXIZXFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:05:16 -0400
Date: Wed, 26 Sep 2007 17:04:37 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI: Fix boot-time hang on G31/G33 PC
In-reply-to: <200709261520.40859.jesse.barnes@intel.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Message-id: <46FAE585.5030306@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070826015556.GC14130@parisc-linux.org>
 <200709261455.56165.jesse.barnes@intel.com> <20070926215648.GA24505@kroah.com>
 <200709261520.40859.jesse.barnes@intel.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wednesday, September 26, 2007 2:56 pm Greg KH wrote:
>> On Wed, Sep 26, 2007 at 02:55:55PM -0700, Jesse Barnes wrote:
>>> On Wednesday, September 26, 2007 2:18 pm Greg KH wrote:
>>>> Due to the issues surrounding this patch, I'm dropping it from my
>>>> repo.
>>> What issues?  Is it causing problems for people?
>> I thought this was the patch that Ivan objected to.
> 
> Yeah, Ivan objected to this, but incorrectly I think.
> 
> Ivan, your concern is about disabling things like interrupt controllers 
> and power management chips during probe right?  You're right that doing 
> that could cause problems if we get and interrupt or PMU event at just 
> the wrong time, but that could just as easily happen if decode was 
> still enabled but the BAR had a bogus address programmed (as it would 
> during probing).
> 
> Ultimately, I don't care much one way or another as long as we can get 
> the desktop platforms fixed somehow.  I think disabling decode is the 
> most correct way of doing this, but I'm open to other solutions (this 
> is the only patch I've seen though that's been tested to solve the 
> problem).

I agree, I've yet to see a single report of an actual problem that 
disabling the decode causes, nor even a theoretical problem which 
couldn't already happen due to the possibility of the device being 
accessed during BAR sizing, which just shouldn't be allowed since it 
can't work with or without this patch.

Until and unless we have something better that fixes the real and 
serious boot-time problems that we need this patch to fix, I would say 
it should stay in.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

