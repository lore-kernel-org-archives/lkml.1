Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbXKHClS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbXKHClS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXKHClH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:41:07 -0500
Received: from ik-out-1112.google.com ([66.249.90.181]:47915 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXKHClE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:41:04 -0500
Message-ID: <4732774C.6020903@codemonkey.ws>
Date: Wed, 07 Nov 2007 20:41:16 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Anthony Liguori <aliguori@us.ibm.com>, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio config_ops refactoring
References: <4730A8F3.6020008@us.ibm.com>	<200711071704.09752.rusty@rustcorp.com.au>	<4731F64A.7080309@us.ibm.com> <200711081320.35844.rusty__6233.15023626692$1194488552$gmane$org@rustcorp.com.au>
In-Reply-To: <200711081320.35844.rusty__6233.15023626692$1194488552$gmane$org@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 08 November 2007 04:30:50 Anthony Liguori wrote:
>> I would prefer that the virtio API not expose a little endian standard.
>> I'm currently converting config->get() ops to ioreadXX depending on the
>> size which already does the endianness conversion for me so this just
>> messes things up.  I think it's better to let the backend deal with
>> endianness since it's trivial to handle for both the PCI backend and the
>> lguest backend (lguest doesn't need to do any endianness conversion).
> 
> -ETOOMUCHMAGIC.  We should either expose all the XX interfaces (but this isn't 
> a high-speed interface, so let's not) or not "sometimes" convert endianness.  
> Getting surprises because a field happens to be packed into 4 bytes is 
> counter-intuitive.

Then I think it's necessary to expose the XX interfaces.  Otherwise, the 
backend has to deal with doing all register operations at a per-byte 
granularity which adds a whole lot of complexity on a per-device basis 
(as opposed to a little complexity once in the transport layer).

You really want to be able to rely on multi-byte atomic operations too 
when setting values.  Otherwise, you need another register to just to 
signal when it's okay for the device to examine any given register.

Regards,

Anthony Liguori

> Since your most trivial implementation is to do a byte at a time, I don't 
> think you have a good argument on that basis either.
> 
> Cheers,
> Rusty.

