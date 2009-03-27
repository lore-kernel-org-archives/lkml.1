Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZC0Inh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZC0Inh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZC0InY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:43:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59707 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbZC0InW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:43:22 -0400
Date: Fri, 27 Mar 2009 09:41:39 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net,
       mschmidt@redhat.com, dada1@cosmosbay.com
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work
	properly in bridge -try4
Message-ID: <20090327084138.GA4582@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090326155205.GA28868@psychotron.englab.brq.redhat.com> <20090327.003819.234492275.davem@davemloft.net> <49CC85E9.7070903@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC85E9.7070903@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fri, Mar 27, 2009 at 08:53:13AM CET, kaber@trash.net wrote:
> David Miller wrote:
>> From: Jiri Pirko <jpirko@redhat.com>
>> Date: Thu, 26 Mar 2009 16:52:06 +0100
>>
>>> (resend, updated changelog, hook moved into skb_bond_should_drop,
>>> skb_bond_should_drop ifdefed)
>>>
>>> Hi all.
>>>
>>> The problem is described in following bugzilla:
>>> https://bugzilla.redhat.com/show_bug.cgi?id=487763
>>  ...
>>> This patch solves the situation in the bonding without touching bridge code,
>>> as Patrick suggested. For every incoming frame to bonding it searches the
>>> destination address in slaves list and if any of slave addresses matches, it
>>> rewrites the address in frame by the adress of bonding master. This ensures that
>>> all frames comming thru the bonding in alb mode have the same address.
>>>
>>> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
>>
>>
>> I don't like the hook, but if that's how it's best done....
>>
>> Patrick, please review this.
>
> Me neither, but I don't think this approach can be done without the
> hook. While I still find it questionable whether this mode really
> needs to be supported for a bridge at all

Well there is I think nothing unusual in this net scheme. And by for example
the increasing setups with kvm/bridging it will be needed more and more.

> , an alternative approach
> would be to have bonding add FDB entries for all secondary MACs to
> make bridging treat them as local.

Yes - that is the clear way. But there's not really straihtforward way to do
this. The clear approach would be to extend struct net_device for list of these
mac addresses and let the drivers (binding) fill it and bridge to process it.
But I don't know.

