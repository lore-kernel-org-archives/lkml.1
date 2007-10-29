Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbXJ2P6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbXJ2P6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbXJ2P6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:58:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43492 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758853AbXJ2P6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:58:33 -0400
Message-ID: <47260326.9050701@garzik.org>
Date: Mon, 29 Oct 2007 11:58:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linux-SCSI <linux-scsi@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [PATCH v4 0/2] [SCSI] Asynchronous event notification	infrastructure
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org> <1193672624.3383.25.camel@localhost.localdomain>
In-Reply-To: <1193672624.3383.25.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2007-10-29 at 10:42 -0400, Jeff Garzik wrote:
>> This is the next revision of the SCSI event notification infrastructure
>> patchset, enabling SATA Asynchronous Notification ("AN") for CD/DVD
>> devices that support it.
>>
>> For devices that support SATA AN (only very recent ones do), this means
>> that HAL and other userspace utilities no longer need to repeatedly poll
>> the CD/DVD device to determine if the user has changed the media.
>>
>> This revision takes into account James' comments from earlier today,
>> modulo the following notes:
>>
>> * I think the various event attributes should always be present,
>>   for all devices at all times.  If various events are not supported,
>>   the attribute will of course return zero (false, not supported).
> 
> Actually, I don't think so.  We have precedent for this in the transport
> classes: if a device doesn't support a feature, we don't export the flag
> for that feature through sysfs.  This allows not only feature control,
> but an immediate view of the device capabilities simply by viewing the
> sysfs directory.

Think about about the values being exported by these sysfs attributes: 
they indicate whether or not that feature is supported.

Thus, using the presence/absence of an attribute to communicate the same 
thing would be redundant.

This suggestion adds a whole lot of complexity -- mirroring every change 
to sdev->supported_events by dynamically adding or removing attributes.

The current nice, simple, elegant bitops-based interface is suddenly a 
lot more cumbersome if forced to deal with attribute creation and disposal.

Finally, this additional complexity of dynamic attribute management also 
eliminates some key information:  userland can test the existence of the 
attribute to determine if that support is present in the kernel.

	Jeff


