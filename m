Return-Path: <linux-kernel-owner+w=401wt.eu-S1761535AbYCUUgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535AbYCUUgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYCUUgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:36:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58532 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbYCUUgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:36:36 -0400
Message-ID: <47E41C50.4020406@garzik.org>
Date: Fri, 21 Mar 2008 16:36:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Subject: Re: [SCSI] fix media change events for polled devices
References: <200803211559.m2LFxPi6017869@hera.kernel.org>	 <47E3EC67.4050404@garzik.org> <1206128662.2961.37.camel@localhost.localdomain>
In-Reply-To: <1206128662.2961.37.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
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
>>
>> Since commit 285e9670 is broken, you fixed the wrong thing.
>>
>> Furthermore, you broke a userspace interface that was introduced by 
>> a341cd0f, by removing the event filter controlled by userspace.
> 
>> Did anyone bother to read any code at all?
> 
> Yes, I did.  The userspace interface has never worked as a writeable
> attribute because it's read only (as Kay has pointed out several times).
> Based on that, I just #if'd out the filter code to get polled media
> events working again.

It has a show attribute and was obviously intended as a writable 
interface (and I should know, I wrote it).


> The filter can be put back with a better discriminator for 2.6.26
> 
>> When 285e9670 was updated for the scsi_evt_* interface, it should have 
>> initialized the supported_events mask.
> 
> That would break HAL ... it's using the presence of the media_event flag
> in the variable to indicate it doesn't need to poll.  We need two flags,
> one for polling and one for AN.

Oh for pete's sake.  How hard is it to create a second bit _and_ keep 
the existing AN featureset working?

_YOU_ are the one that broke this stuff in the first place, can you 
please take two seconds to fix it without breaking other stuff?

	Jeff



