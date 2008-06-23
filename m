Return-Path: <linux-kernel-owner+w=401wt.eu-S1762754AbYFWTHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762754AbYFWTHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbYFWTHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:07:21 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:57300 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbYFWTHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:07:19 -0400
Message-ID: <485FF44C.4010600@csr.com>
Date: Mon, 23 Jun 2008 20:06:52 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>, linux-usb@vger.kernel.org,
       "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Subject: Re: Scatter-gather list constraints
References: <Pine.LNX.4.44L0.0806231109280.2556-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806231109280.2556-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2008 19:06:52.0365 (UTC) FILETIME=[4BB4DFD0:01C8D564]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 23 Jun 2008, David Vrabel wrote:
> 
>> Note that this 1024 byte multiple is for one particular WUSB mass
>> storage device.  The WUSB standard permits max packet sizes of up 3584
>> (in multiples of 512), but I suspect WUSB mass storage devices will only
>> use 512, 1024, or 2048.
>>
>> For a solution, we may be able to do something if the HWA host
>> controller is passed a single URB with an s-g list (rather than one URB
>> per s-g list entry) and was careful about how it segmented the URB into
>> transfers to the rpipe.
> 
> That would be ideal.  However there is no way to pass an S-G list along 
> with an URB; there's no field for it in the data structure.  And none 
> of the existing host controller drivers support such a thing.
> 
> I suppose we could add a field to struct urb and add a flag indicating 
> whether the controller driver supports S-G lists.

This is what I was thinking.

Can the number of entries in a sg list be limited?  e.g., if the
hardware only had support for say, 64 entries?

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
