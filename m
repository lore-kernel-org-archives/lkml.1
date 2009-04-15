Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZDOOpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZDOOpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZDOOov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:44:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35606 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZDOOov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:44:51 -0400
Date: Wed, 15 Apr 2009 16:42:05 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, dada1@cosmosbay.com,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net,
       mschmidt@redhat.com, ivecera@redhat.com
Subject: Re: [PATCH 1/3] net: introduce a list of device addresses
	dev_addr_list
Message-ID: <20090415144204.GI21342@psychotron.englab.brq.redhat.com>
References: <49E59A1C.9030108@cn.fujitsu.com> <20090415083223.GF21342@psychotron.englab.brq.redhat.com> <49E5A896.90408@cosmosbay.com> <20090415.023104.82135803.davem@davemloft.net> <49E5B365.2010008@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E5B365.2010008@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wed, Apr 15, 2009 at 12:13:57PM CEST, kaber@trash.net wrote:
> David Miller wrote:
>> From: Eric Dumazet <dada1@cosmosbay.com>
>> Date: Wed, 15 Apr 2009 11:27:50 +0200
>>
>>> Since you obviously need a write lock here to be sure following
>>> can be done by one cpu only.
>>>
>>> You have same problem all over this patch.
>>
>> RTNL semaphore is held across all modification operations.
>
> If this will also be used for multicast lists, changes can happen
> (IPv6) without the RTNL.

Ok, but for dev_addr_X() functions the RTNL mutex is sufficient so I see no
point of adding another lock here. When the multicast handling functions will be
implemented to use netdev_hw_addr and it's layer, then we need to use update
lock in dev_multicast_X.
