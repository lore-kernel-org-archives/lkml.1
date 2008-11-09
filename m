Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYKID4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYKID4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 22:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYKID4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 22:56:12 -0500
Received: from hq2.tensilica.com ([65.205.227.30]:29414 "EHLO
	maia.hq.tensilica.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753825AbYKID4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 22:56:12 -0500
Message-ID: <49165F4A.4070905@tensilica.com>
Date: Sat, 08 Nov 2008 19:55:54 -0800
From: Piet Delaney <piet.delaney@tensilica.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Chris Zankel <chris@zankel.net>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Marc Gauthier <marc@tensilica.com>,
       Joe Taylor <joetayloremail@gmail.com>, linux-xtensa@linux-xtensa.org,
       Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 10/10] xtensa: use the new byteorder headers - Merged
 with your previous xtensa-next and will remerge shortly.
References: <1225910131.5991.230.camel@brick> <49133094.6070407@zankel.net>	 <491500C0.90407@tensilica.com> <1226115481.11596.63.camel@brick>
In-Reply-To: <1226115481.11596.63.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Fri, 2008-11-07 at 19:00 -0800, Piet Delaney wrote:
>> Hi Chris:
>>
>>    I've merged your recent xtensa-next with our 2.6.24-smp repo.
>> It seems to work fine and I'm in the process of cleaning it
>> up a bit and adding preliminary XTENSA kgdb support.
> 
> 2.6.24?  In that case you probably don't have include/linux/byteorder.h,
> or include/linux/swab.h which would explain your byteorder problems.
> 
> Or is that a typo in the version numbers?

I was on 2.6.24 and didn't have a problem compiling the kernel -O0 other
than a minor tweak in slab.c. Now in 2.6.27-rc3 I get a compile problem
with rpcb_clnt.c at lines 122, 123, and 129:

    /export/src/xtensa-next/net/sunrpc/rpcb_clnt.c:129: error: (near initialization for 'rpcb_in6addr_loopback.sin6_port')


> 
> You should be able to just pull those two headers from Linus' tree
> and drop them in, there is no dependencies other than those two
> headers.

byteorder.h was already in sync with linus's tree and I updated swab.c
as it had a few changes. Unfortunately the problem persist. I think the
problem is likely in changes made to rpcb_clnt.c since 2.6.24.

> 
> If it is some other problem, let me know and I'll look into it.

You can likely reproduce it by configuring NFS and compiling -O0.

-piet

> 
> Harvey
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
