Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbZC0HzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbZC0HzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbZC0Hx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:53:26 -0400
Received: from stinky.trash.net ([213.144.137.162]:52636 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbZC0HxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:53:24 -0400
Message-ID: <49CC85E9.7070903@trash.net>
Date: Fri, 27 Mar 2009 08:53:13 +0100
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
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com>	<20090326155205.GA28868@psychotron.englab.brq.redhat.com> <20090327.003819.234492275.davem@davemloft.net>
In-Reply-To: <20090327.003819.234492275.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jiri Pirko <jpirko@redhat.com>
> Date: Thu, 26 Mar 2009 16:52:06 +0100
> 
>> (resend, updated changelog, hook moved into skb_bond_should_drop,
>> skb_bond_should_drop ifdefed)
>>
>> Hi all.
>>
>> The problem is described in following bugzilla:
>> https://bugzilla.redhat.com/show_bug.cgi?id=487763
>  ...
>> This patch solves the situation in the bonding without touching bridge code,
>> as Patrick suggested. For every incoming frame to bonding it searches the
>> destination address in slaves list and if any of slave addresses matches, it
>> rewrites the address in frame by the adress of bonding master. This ensures that
>> all frames comming thru the bonding in alb mode have the same address.
>>
>> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> 
> 
> I don't like the hook, but if that's how it's best done....
> 
> Patrick, please review this.

Me neither, but I don't think this approach can be done without the
hook. While I still find it questionable whether this mode really
needs to be supported for a bridge at all, an alternative approach
would be to have bonding add FDB entries for all secondary MACs to
make bridging treat them as local.
