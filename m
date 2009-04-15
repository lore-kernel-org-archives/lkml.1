Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZDOPh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZDOPh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZDOPhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:37:47 -0400
Received: from rtr.ca ([76.10.145.34]:39945 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbZDOPhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:37:46 -0400
Message-ID: <49E5FF48.3030809@rtr.ca>
Date: Wed, 15 Apr 2009 11:37:44 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
References: <49E4FAC6.1030400@garzik.org>	<20090415014930.GA29413@kroah.com>	<49E5480F.10501@garzik.org>	<20090415050947.GB3462@kroah.com>	<49E5EE41.3090505@rtr.ca> <20090415073001.503b0361@infradead.org>
In-Reply-To: <20090415073001.503b0361@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 15 Apr 2009 10:25:05 -0400
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Greg KH wrote:
>>> ..
>>> The issue is that you were just lucky that your machine worked
>>> properly previously.  My boxes with the same type of setup didn't,
>>> so I quickly realized what the root delay boot option was for.  You
>>> need to just do the same thing here, there's nothing else we can do.
>> ..
>>
>> Bad excuse.
>>
>> SATA drives also take variable amounts of time to "show up" at boot.
>> Perhaps Jeff should customize libata for your and Arjan's exact
>> setups, just to help with understanding the point here.  :)
> 
> the difference is that with sata you know when you are done and have all
> possible drives. No so much much with USB. So with SATA we can, and do,
> wait for the scan to complete at the right point in the boot.
> 
>> The speed ups are fine (and welcome), but we really now need
>> Arjan to follow-up with a patch to have the kernel *by default*
>> wait a little longer for the rootfs to show up.
>>
>> Not forever, just a few seconds to compensate for the regression.
> 
> seconds!!!!!
> The whole kernel boots in half a second!
..

Oh, absolutely I agree.

That's why I'm not suggesting a DELAY,
but rather a TIMEOUT (where it keeps trying up until the timeout).

For desktop, it should really just wait forever,
but I can understand situations (server room)
where that would be a Really Bad Idea.

So just have it sit there and retry the rootfs for a few seconds,
to compensate for this regression and also for others that have
yet to be discovered / reported.

Everyone's life will be easier that way.

Cheers
