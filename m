Return-Path: <linux-kernel-owner+w=401wt.eu-S1761866AbYCUUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761866AbYCUUnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbYCUUnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:43:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45128 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760956AbYCUUnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:43:01 -0400
Message-ID: <47E41DD3.2040602@garzik.org>
Date: Fri, 21 Mar 2008 16:42:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Subject: Re: [SCSI] fix media change events for polled devices
References: <200803211559.m2LFxPi6017869@hera.kernel.org>	 <47E3EC67.4050404@garzik.org> <1206124426.24338.20.camel@lov.site>
In-Reply-To: <1206124426.24338.20.camel@lov.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Fri, 2008-03-21 at 13:12 -0400, Jeff Garzik wrote:
>> Linux Kernel Mailing List wrote:
>>>     [SCSI] fix media change events for polled devices
>>>     
>>>     Commit:
>>>       a341cd0f (SCSI: add asynchronous event notification API)
>>>     breaks:
>>>       285e9670 (sr,sd: send media state change modification events)
>>>     by introducing an event filter, which is removed here, to make
>>>     events, we are depending on, happen again.
>>
>> By simply reading the code history, it is trivial to verify that this 
>> description is false:
>>
>> Commit 285e9670 depends on a341cd0f, so by definition it is 285e9670 -- 
>> or rather the incomplete update of your original patch that resulted in 
>> 285e9670 -- that is broken.
> 
> It worked fine with Kristen's patches, and that's where it is coming
> from from.

Neither her patches nor yours went upstream verbatim at version one. 
You need to look at what happens upstream, not what happened in your 
private testing six months ago.


> You mean the read-only sysfs attribute? :)

I mean the attribute with both 'show' (read) and 'store' (write) 
functions.  The perms do need to change, thanks for noticing that bug.


> 
>> Did anyone bother to read any code at all?
>>
>> When 285e9670 was updated for the scsi_evt_* interface, it should have 
>> initialized the supported_events mask.
>>
>> And that is the fix -- initialize supported_events according to sr/sd's 
>> needs, and revert this change (4d1566ed2100d074ccc654e5cf2e44cdea3a01d0) 
>> as obviously broken.
> 
> You mean adding a new flag? As every device will "support" these events.

Does every device attached to every controller wish to fire these events?

If so, then that wants new flag, yes.

	Jeff


