Return-Path: <linux-kernel-owner+w=401wt.eu-S935054AbZKYUxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935054AbZKYUxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935045AbZKYUxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:53:44 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:42898 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935044AbZKYUxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:53:43 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2009 15:53:43 EST
Message-ID: <4B0D96EB.9030104@collabora.co.uk>
Date: Wed, 25 Nov 2009 20:43:23 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hw_random fixes
References: <4B080621.5000109@collabora.co.uk>	 <4B0C18B0.2000206@collabora.co.uk> <1259084901.17871.624.camel@calx>	 <200911251135.41871.rusty@rustcorp.com.au> <4B0D03FC.40406@collabora.co.uk> <1259177252.2858.17.camel@calx>
In-Reply-To: <1259177252.2858.17.camel@calx>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> [cc:ing to linux-kernel, finally]
> 
> On Wed, 2009-11-25 at 10:16 +0000, Ian Molton wrote:
>> Rusty Russell wrote:
>>
>>> Make that:
>>>
>>> 	ssize_t (*get_rng_data)(void *buf, size_t max, bool wait);
>>>
>>> Then, if driver supplies that hook, use it exclusively.  Otherwise, use old
>>> ones.  We can convert them gradually that way.
>> This doesn't quite solve things neatly, because it means one of:
>>
>> 1) The core has to wait until there is nothing left before requesting
>> more data, because it doesnt know the alignment requirements of the driver.
> 
> Hmm, this seems to imply you'd be calling get_rng_data multiple times
> with different offsets into buf to accumulate data.

Well, I was hoping to, since it'd mean we accumulate spare bytes from
those drivers that can return more than one at a time but not less than
4 or 8. IMO though its just not worth handling the corner cases this
causes so I agree, just using it as a scratch buffer is best.

One or two drivers are completion based so they'd need to quiesce before
 shutdown / change, too.

> You'll probably want to use cacheline alignment on buf to make Via
> Padlock happy,

Noted.

