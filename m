Return-Path: <linux-kernel-owner+w=401wt.eu-S1751436AbZC3Mnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbZC3Mnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZC3Mng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:43:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37976 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbZC3Mnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:43:35 -0400
Date: Mon, 30 Mar 2009 14:40:56 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net,
       mschmidt@redhat.com, dada1@cosmosbay.com
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work
	properly in bridge -try4
Message-ID: <20090330124049.GD3438@psychotron.englab.brq.redhat.com>
References: <20090326155205.GA28868@psychotron.englab.brq.redhat.com> <20090327.003819.234492275.davem@davemloft.net> <49CC85E9.7070903@trash.net> <20090329.135355.109115565.davem@davemloft.net> <49D0B549.3050900@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D0B549.3050900@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, Mar 30, 2009 at 02:04:25PM CEST, kaber@trash.net wrote:
> David Miller wrote:
>> From: Patrick McHardy <kaber@trash.net>
>> Date: Fri, 27 Mar 2009 08:53:13 +0100
>>
>>> ... an alternative approach
>>> would be to have bonding add FDB entries for all secondary MACs to
>>> make bridging treat them as local.
>>
>> Do you guys foresee any possibility of an alternative implementation
>> any time soon?
>>
>> Otherwise we're just stalling by not putting something into the tree,
>> and as far as I can tell this patch here might as well be it.
>
> Adding bridge FDB entries seems like the best fix. It might
> need some minor ugliness to avoid new dependencies between
> bonding and bridging, but it definitely beats having new hooks
> in the core in my opinion.

Agree with this.
>
> But I have no idea whether Jiri is actually implementing this.

Currently I'm thinking the way. What I have on mind:
I would like to add a list into struct net_device to contain all mac addresses
of the device. I would also like to use similar interface to handle them as
currently is for uc_list and mc_list. However I do not like that these lists are
not using standard list_head but they are propriate lists only for this purpose.
I'm thinking about converting them to use list_head first. Or maybe ignore them
and do the new list for macs in parallel?

Then we can fill this list with macs in bonding driver and let bridge check it
and make fdb entries.
