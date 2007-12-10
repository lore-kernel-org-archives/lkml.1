Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbXLJOs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbXLJOs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXLJOsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:48:51 -0500
Received: from tornado.reub.net ([59.167.253.246]:52143 "EHLO tornado.reub.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXLJOsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:48:50 -0500
X-DKIM: Sendmail DKIM Filter v2.3.2 tornado.reub.net 2AEE6129AD0
Message-ID: <475D51C7.6010809@reub.net>
Date: Tue, 11 Dec 2007 01:48:39 +1100
From: Reuben Farrelly <reuben-linuxkernel@reub.net>
User-Agent: Thunderbird 2.0.0.12pre (Windows/20071209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
In-Reply-To: <20071204211701.994dfce6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/12/2007 4:17 PM, Andrew Morton wrote:
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.24-rc4-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/
> 
> 
> - Lots of device IDs have been removed from the e1000 driver and moved over
>   to e1000e.  So if your e1000 stops working, you forgot to set CONFIG_E1000E.
> 
> - The s390 build is still broken.

I'm seeing this most incredibly unhelpful (to debug) but fortunately
reproduceable problem (so far 4/4 times) on this -mm kernel.  I thought this 
problem may have been related to another bug which I have reported (A TCP oops) 
but even after applying a likely fix for that I am still seeing this problem.

The machine boots up perfectly fine and runs good until I load it up.
In this case I can reliably cause this to occur by pulling a 3G ISO across the
GigE network from my Linux box to my PC.  After maybe 50M or so, the console 
just displays this (ignore initial boot banner):

----------

  * Starting local ...                                                     [ ok ]


This is tornado.reub.net (Linux x86_64 2.6.24-rc4-mm1) 00:24:01

tornado login: *** buffer overf

-------

Yes - after displaying the 'f' in what I can only guess is the word 'overflow',
the box spontaneously reboots.  There is no further console output until it 
starts to come back up again.

The problem does not exist in 2.6.23-gentoo kernels nor in a vanilla 
2.6.24-rc4-git6 (phew!), so this looks to be an -mm only problem at this stage.

I enabled a number of kernel debugging options but then I got no output at all 
when the machine crashed.

I'm at a bit of a loss as to which subsystem this might be coming from, so I'm 
not sure who to CC.

Box information is (still) up at http://www.reub.net/files/kernel/2.6.24-rc4-mm1/

Thanks,
Reuben




