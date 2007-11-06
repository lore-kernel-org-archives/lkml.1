Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbXKFXFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbXKFXFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbXKFXFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:05:44 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40273 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXKFXFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:05:43 -0500
Message-ID: <4730F351.5060006@us.ibm.com>
Date: Tue, 06 Nov 2007 17:05:53 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Dor Laor <dor.laor@qumranet.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: Re: virtio config_ops refactoring
References: <4730A8F3.6020008@us.ibm.com> <200711070957.44165.rusty__13109.5125260346$1194390035$gmane$org@rustcorp.com.au>
In-Reply-To: <200711070957.44165.rusty__13109.5125260346$1194390035$gmane$org@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 07 November 2007 04:48:35 Anthony Liguori wrote:
>> Semantically, find requires that a field have both a type and a length.
>> With the exception of the VIRTQUEUE field used internally by lguest,
>> type is always a unique identifier.  Since virtqueue information is not
>> a required part of the config space, it seems to me that type really
>> should be treated as a unique identifier.
> 
> Hi Anthony,
> 
> 	Not sure I get this.  It is a unique identifier.  You need the length
> to handle unknown fields.

It's not a unique identifier since it can be used for multiple items 
(like it is for virtqueues configs).

>> find_vq also is curious in that it is stateful in it's enumeration.
> 
> Well, they're *all* stateful.  This gives a simple method of knowing what 
> fields the guest understands: it marks the fields as it finds them.  Then it 
> sets the status, which allows the host to know when it's completed 
> configuration reads.

But PCI device configuration is not stateful.  If you care about letting 
the host know what features a guest understands, I think something more 
explicit and stateful should be used.  For instance, a feature register 
that stores a bitmap.

Otherwise, the host has to infer based on what fields that guest has 
read what features the guest actually supports.  That seems error prone 
to me.

> I like enumerating the virtqueues: it's not necessary but it's clearer.
> 
>> This adds seemingly unnecessary complexity.
> 
> I'd be happy for a simpler mechanism...

What do you think of what I proposed?  It seems simpler to me.

Regards,

Anthony Liguori

> Cheers,
> Rusty.

