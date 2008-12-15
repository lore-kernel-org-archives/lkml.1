Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYLONdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYLONdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYLONc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 08:32:56 -0500
Received: from stinky.trash.net ([213.144.137.162]:56704 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYLONcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 08:32:55 -0500
Message-ID: <49465C7E.8050103@trash.net>
Date: Mon, 15 Dec 2008 14:32:46 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
CC: Jan Engelhardt <jengelh@medozas.de>, David Miller <davem@davemloft.net>,
       ajax@redhat.com, linux-kernel@vger.kernel.org, davej@redhat.com,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] net: Remove a noisy printk
References: <1229033625-30825-1-git-send-email-ajax@redhat.com> <20081211.203243.124017657.davem@davemloft.net> <alpine.LNX.1.10.0812132310080.27276@fbirervta.pbzchgretzou.qr> <alpine.DEB.2.00.0812141745550.2447@blackhole.kfki.hu> <alpine.LNX.1.10.0812141905490.10355@fbirervta.pbzchgretzou.qr> <alpine.DEB.2.00.0812142056520.2621@blackhole.kfki.hu> <49464C2C.6030009@trash.net> <alpine.DEB.2.00.0812151419380.4114@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.00.0812151419380.4114@blackhole.kfki.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jozsef Kadlecsik wrote:
> On Mon, 15 Dec 2008, Patrick McHardy wrote:
> 
>> I agree that it doesn't belong to the generic networking code.
>> But the way its handled in netfilter is far from perfect as well.
>> Currently multiple modules will spam the ringbuffer repeatedly,
>> but offer no possibility to change anything in the behaviour of
>> how these packets are treated. Unfortunately we can't handle this
>> in the ruleset (which is exactly the reason why we're spamming
>> the ringbuffer), so how about we add a module option controlling
>> how to treat those packets and remove the printk?
> 
> How about this: let the printk be removed from conntrack and the mangle 
> table but put (back) into the filter table with a module option, which 
> controls the behaviour (drop/accept & log/nolog)?

Sounds fine to me. We can't log it in the usual way though
(ipt_LOG/nfnetlink_log) and spamming the ringbuffer should
really be a last resort, so I'd prefer to limit it to print
the message exactly once.
