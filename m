Return-Path: <linux-kernel-owner+w=401wt.eu-S933701AbXCSCea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbXCSCea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 22:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933730AbXCSCea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 22:34:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:33744 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933701AbXCSCe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 22:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=I/X/A6+Pxhp2Mc+JtKkte43q3IuKEVPhEf4qwAL4WzBb520ffoy0W+McWXxKhXNRciN/FtIiktF3AE9o2LcUCb0JMfchApQWArtUUr6UHs3spel8UeE1WMIPa0U4qw9Go2/5LWXJkOJ19EYyv9wT3UQPOyXmujDCoZKi4oW80hw=
Message-ID: <59ad55d30703181934o1442ab44rcc11fbeac62ca7c0@mail.gmail.com>
Date: Sun, 18 Mar 2007 22:34:27 -0400
From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: remove usage of skb_queue as packet queue
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.be8814c580bba408@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <tkrat.be8814c580bba408@s5r6.in-berlin.de>
X-Google-Sender-Auth: 905e41d96ea1dc71
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/17/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> This considerably reduces the memory requirements for a packet and
> eliminates ieee1394's dependency on CONFIG_NET.

Nice work Stefan, the skb rewrite was one of the most pointless
rewrites in the history of the linux1394 stack.

> TODO:
>   - Double-check if there are any drivers whose packet complete routine
>     really needs process context. If there are none, get rid of khpsbpkt
>     and execute the complete routine in the low-level driver's bottom
>     half's context.

Yup, mandatory running in process context is braindead, since most
complete routines just need to complete a completion or schedule some
work.

>   - Check whether the complete packet really has to be zeroed when
>     allocated.
>   - Allocate small frequently used packets (e.g. quadlet read requests
>     and 4...8 bytes write requests) from a kmem_cache. Append separately
>     allocated data sections only if necessary.

Not sure if this is worth it, kmalloc is pretty fast these days.

Hehe, you're reverting the bad decisions that made me tune out from
linux1394 development a few years back.  But the question is, is it
worth it?  One of the primary reasons for me to write an alternative
stack was to be able to leave linux1394 in maintenence mode.  This way
I wont screw up existing functionality in the old stack, and will be
able to make big changes without worrying about porting over every
single driver.

Kristian
