Return-Path: <linux-kernel-owner+w=401wt.eu-S933817AbZKXSCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbZKXSCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933769AbZKXSCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:02:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50168
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933580AbZKXSCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:02:18 -0500
Date: Tue, 24 Nov 2009 10:02:36 -0800 (PST)
Message-Id: <20091124.100236.135630809.davem@davemloft.net>
To: florian@openwrt.org
Cc: ralf@linux-mips.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, a.beregalov@gmail.com,
       linux-mips@linux-mips.org, manuel.lauss@googlemail.com
Subject: Re: linux-next: manual merge of the mips tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200911241230.22370.florian@openwrt.org>
References: <20091124011958.GA8105@linux-mips.org>
	<20091123.194343.232255103.davem@davemloft.net>
	<200911241230.22370.florian@openwrt.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>
Date: Tue, 24 Nov 2009 12:30:22 +0100

> On Tuesday 24 November 2009 04:43:43 David Miller wrote:
>> From: Ralf Baechle <ralf@linux-mips.org>
>> Date: Tue, 24 Nov 2009 01:19:58 +0000
>> 
>> > On Tue, Nov 24, 2009 at 11:37:17AM +1100, Stephen Rothwell wrote:
>> >> Hi Ralf,
>> >>
>> >> Today's linux-next merge of the mips tree got a conflict in
>> >> drivers/net/au1000_eth.c between commit
>> >> 63edaf647607795a065e6956a79c47f500dc8447 ("Au1x00: fix crash when trying
>> >> register_netdev()") from the net-current tree and commit
>> >> 6cdbc95856e7f4ab4e7b2f2bdab5c3844537ad83 ("NET: au1000-eth: convert to
>> >> platform_driver model") from the mips tree.
>> >>
>> >> It looks to me that the mips tree change supercedes the net-current one
>> >> (since it moves the register_netdev() call much later), so I just used
>> >> this file from the mips tree.
>> >
>> > I agree.  David, can you just drop the net-current patch then?  This fix
>> > is still needed for -stable however.
>> 
>> Why would I do that?  The bug fix is necessary for 2.6.32 too.
> 
> Ok, it is, but the platform_driver conversion patch is heavier, so the bugfix 
> is way easier to apply on thom of the conversion.

But the conversion is not appropriate for 2.6.32, and since I have to push
the bug fix into 2.6.32 anyways you have to live with resolving the conflict
somehow since the bug fix by itself is going to go to Linus for 2.6.32 but
your conversion is not.
