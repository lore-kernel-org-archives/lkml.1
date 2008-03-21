Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbYCUVK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbYCUVK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761659AbYCUVKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:10:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54359 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761449AbYCUVKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:10:43 -0400
Message-ID: <47E42450.2000104@garzik.org>
Date: Fri, 21 Mar 2008 17:10:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Kay Sievers <kay.sievers@vrfy.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Subject: Re: [SCSI] fix media change events for polled devices
References: <200803211559.m2LFxPi6017869@hera.kernel.org>	 <47E3EC67.4050404@garzik.org> <1206124426.24338.20.camel@lov.site>	 <47E41DD3.2040602@garzik.org> <1206133474.2961.49.camel@localhost.localdomain>
In-Reply-To: <1206133474.2961.49.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Fri, 2008-03-21 at 16:42 -0400, Jeff Garzik wrote:
>> Kay Sievers wrote:
>>> On Fri, 2008-03-21 at 13:12 -0400, Jeff Garzik wrote:
>>>> Linux Kernel Mailing List wrote:
>>>>>     [SCSI] fix media change events for polled devices
>>>>>     
>>>>>     Commit:
>>>>>       a341cd0f (SCSI: add asynchronous event notification API)
>>>>>     breaks:
>>>>>       285e9670 (sr,sd: send media state change modification events)
>>>>>     by introducing an event filter, which is removed here, to make
>>>>>     events, we are depending on, happen again.
>>>> By simply reading the code history, it is trivial to verify that this 
>>>> description is false:
>>>>
>>>> Commit 285e9670 depends on a341cd0f, so by definition it is 285e9670 -- 
>>>> or rather the incomplete update of your original patch that resulted in 
>>>> 285e9670 -- that is broken.
>>> It worked fine with Kristen's patches, and that's where it is coming
>>> from from.
>> Neither her patches nor yours went upstream verbatim at version one. 
>> You need to look at what happens upstream, not what happened in your 
>> private testing six months ago.
>>
>>
>>> You mean the read-only sysfs attribute? :)
>> I mean the attribute with both 'show' (read) and 'store' (write) 
>> functions.  The perms do need to change, thanks for noticing that bug.
> 
> That's not a bug.

Yes, it is.  That sysfs node was intended to be writable.


> For starters, we have transport classes that provide generic store
> methods but can't pass the information on to drivers.  For these, we set
> the attribute to read only even if there is a store method.  Even if
> that weren't the case, how do you know which of UGO wants the write
> setting?

You give it to root, and let userspace change it after that, like we 
always do.

	Jeff



