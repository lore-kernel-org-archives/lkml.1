Return-Path: <linux-kernel-owner+w=401wt.eu-S1750977AbXDAR3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977AbXDAR3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXDAR3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:29:41 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63676 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbXDAR3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:29:40 -0400
Date: Sun, 01 Apr 2007 11:28:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
In-reply-to: <fa.BiSx71HKysC9QIpS8DLip5BmfxI@ifi.uio.no>
To: Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Message-id: <460FEBB6.2040007@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.NmF2xJwO4BeVbJrFRkf7oV9EYmQ@ifi.uio.no>
 <fa.39luedDWsoqip+QMNtfAv8jvyNg@ifi.uio.no>
 <fa.b1cZfpMNhZ0teK/UauKLDWw60Jc@ifi.uio.no>
 <fa.xWaBy6HZTRTgI+PxinV8ajuOlJI@ifi.uio.no>
 <fa.BiSx71HKysC9QIpS8DLip5BmfxI@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Jeff Garzik wrote:
>> NCQ provides for a more asynchronous flow.  It helps greatly with 
>> reads (of which most are, by nature, synchronous at the app level) 
>> from multiple threads or apps.  It helps with writes, even with write 
>> cache on, by allowing multiple commands to be submitted and/or retired 
>> at the same time.
> 
> But when writing, what is the difference between queuing multiple tagged 
> writes, and sending down multiple untagged cached writes that complete 
> immediately and actually hit the disk later?  Either way the host keeps 
> sending writes to the disk until it's buffers are full, and the disk is 
> constantly trying to commit those buffers to the media in the most 
> optimal order.

As well as what others have pointed out, without NCQ the disk is forced 
to accept the data in the order that the host provides it. If the host 
writes a burst of data that doesn't fill the write cache it's not as 
much of an issue, but if the write cache fills up then the disk may have 
to flush out data in a suboptimal order since it can't see what other 
requests are coming and can't change the order in which that data shows up.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

