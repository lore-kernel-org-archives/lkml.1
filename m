Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZC3MEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZC3MEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZC3ME3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:04:29 -0400
Received: from stinky.trash.net ([213.144.137.162]:59367 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZC3ME2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:04:28 -0400
Message-ID: <49D0B549.3050900@trash.net>
Date: Mon, 30 Mar 2009 14:04:25 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jpirko@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, mschmidt@redhat.com,
       dada1@cosmosbay.com
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work properly
 in bridge -try4
References: <20090326155205.GA28868@psychotron.englab.brq.redhat.com>	<20090327.003819.234492275.davem@davemloft.net>	<49CC85E9.7070903@trash.net> <20090329.135355.109115565.davem@davemloft.net>
In-Reply-To: <20090329.135355.109115565.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Fri, 27 Mar 2009 08:53:13 +0100
> 
>> ... an alternative approach
>> would be to have bonding add FDB entries for all secondary MACs to
>> make bridging treat them as local.
> 
> Do you guys foresee any possibility of an alternative implementation
> any time soon?
> 
> Otherwise we're just stalling by not putting something into the tree,
> and as far as I can tell this patch here might as well be it.

Adding bridge FDB entries seems like the best fix. It might
need some minor ugliness to avoid new dependencies between
bonding and bridging, but it definitely beats having new hooks
in the core in my opinion.

But I have no idea whether Jiri is actually implementing this.
