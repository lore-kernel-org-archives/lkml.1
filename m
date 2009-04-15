Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZDOVzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZDOVzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZDOVzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:55:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38315 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbZDOVzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:55:13 -0400
Date: Wed, 15 Apr 2009 23:55:09 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>,
       Jeff Chua <jeff.chua.linux@gmail.com>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>, paulus@samba.org, mingo@elte.hu,
       torvalds@linux-foundation.org, laijs@cn.fujitsu.com, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
In-Reply-To: <49E64C91.5020708@cosmosbay.com>
Message-ID: <alpine.LSU.2.00.0904152354330.5844@fbirervta.pbzchgretzou.qr>
References: <20090411174801.GG6822@linux.vnet.ibm.com> <18913.53699.544083.320542@cargo.ozlabs.ibm.com> <20090412173108.GO6822@linux.vnet.ibm.com> <20090412.181330.23529546.davem@davemloft.net> <20090413040413.GQ6822@linux.vnet.ibm.com> <20090413095309.631cf395@nehalam>
 <49E48136.5060700@trash.net> <49E49C65.8060808@cosmosbay.com> <20090414074554.7fa73e2f@nehalam> <49E4B0A5.70404@cosmosbay.com> <b6a2187b0904140951r3c6a41fdnc26b149202bdfa84@mail.gmail.com> <20090414111716.28585806@nehalam> <49E4E3E8.5090201@cosmosbay.com>
 <20090414141351.0f63ac98@nehalam> <49E502B5.7070700@cosmosbay.com> <49E5BDF7.8090502@trash.net> <20090415135526.2afc4d18@nehalam> <49E64C91.5020708@cosmosbay.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2009-04-15 23:07, Eric Dumazet wrote:
>Stephen Hemminger a écrit :
>> Looks like there is some recursive path into ip_tables that makes the
>> per-cpu spinlock break.  I get lockup's with KVM networking.
>> 
>> Suggestions?
>
>Well, it seems original patch was not so bad after all
>
>http://lists.netfilter.org/pipermail/netfilter-devel/2006-January/023175.html
>
>So change per-cpu spinlocks to per-cpu rwlocks 
>
>and use read_lock() in ipt_do_table() to allow recursion...
>
iptables cannot quite recurse into itself due to the comefrom stuff.

