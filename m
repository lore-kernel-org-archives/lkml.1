Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbXJSLSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbXJSLSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbXJSLRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:17:55 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:6597 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXJSLRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:17:54 -0400
Message-ID: <47189242.8090006@fr.ibm.com>
Date: Fri, 19 Oct 2007 13:17:22 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: schwidefsky@de.ibm.com, "Serge E. Hallyn" <serge@hallyn.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com,
       heiko.carstens@de.ibm.com, sam@ravnborg.org,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org
Subject: Re: 2.6.23-mm1 s390 driver problem
References: <20071018200148.GA14234@vino.hallyn.com> <200710182215.56428.borntraeger@de.ibm.com> <20071018203151.GA15382@vino.hallyn.com> <1192780036.25150.7.camel@localhost> <471875E0.8040308@fr.ibm.com> <20071019022719.537ee71f.akpm@linux-foundation.org>
In-Reply-To: <20071019022719.537ee71f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> that helped going a little further in the boot process but we then have 
>> a network issue when bringing the network interface up :
> 
> please cc netdev on network issues.

yes.

>> Bringing up interface eth0:  ------------Ý cut here ¨------------ 
>> Kernel BUG at 0000000000000002 Ýverbose debug info unavailable¨ 
>> illegal operation: 0001 Ý#1¨ 
>> Modules linked in: 
>> CPU:    0    Not tainted 
>> Process ip (pid: 1167, task: 0000000001d46038, ksp: 00000000025efb28) 
>> Krnl PSW : 0704200180000000 0000000000000002 (0x2) 
>>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3 
>> Krnl GPRS: 0000000000000000 0000000000000000 000000000241f600 0000000001c8d
>>            00000000000086dd 0000000001eb6d70 0000000000000000 0000000001c8d
>>            0000000001eb6d40 00000000003abc28 0000000001eb6d00 00000000025ef
>>            000000000241f600 00000000003b6d18 00000000002b33d2 00000000025ef
>> Krnl Code:>0000000000000002: 0000               unknown 
>>            0000000000000004: 0000               unknown 
>>            0000000000000006: 0000               unknown 
>>            0000000000000008: 0000               unknown 
>>            000000000000000a: 0000               unknown 
>>            000000000000000c: 0000               unknown 
>>            000000000000000e: 0000               unknown 
>>            0000000000000010: 0000               unknown 
>> Call Trace: 
>> (Ý<00000000002b3352>¨ neigh_connected_output+0x76/0x138) 
>>  Ý<0000000000325402>¨ ip6_output2+0x2da/0x470 
>>  Ý<0000000000326ea6>¨ ip6_output+0x816/0x1064 
>>  Ý<0000000000338e46>¨ __ndisc_send+0x416/0x6a8 
>>  Ý<0000000000339330>¨ ndisc_send_rs+0x58/0x68 
>>  Ý<000000000032cbf4>¨ addrconf_dad_completed+0xbc/0x100 
>>  Ý<000000000032d2de>¨ addrconf_dad_start+0xa2/0x14c 
>>  Ý<000000000032d408>¨ addrconf_add_linklocal+0x80/0xa8 
>>  Ý<000000000032fa7e>¨ addrconf_notify+0x2de/0x8d4 
>>  Ý<0000000000383990>¨ notifier_call_chain+0x5c/0x98 
>>  Ý<0000000000063bca>¨ __raw_notifier_call_chain+0x26/0x34 
>>  Ý<0000000000063c06>¨ raw_notifier_call_chain+0x2e/0x3c 
>>  Ý<00000000002aa54c>¨ call_netdevice_notifiers+0x34/0x44 
>>  Ý<00000000002ad1aa>¨ dev_open+0x9e/0xe0 
>>  Ý<00000000002ad80a>¨ dev_change_flags+0x9e/0x1cc 
>>  Ý<0000000000302c74>¨ devinet_ioctl+0x650/0x73c 
>>  Ý<00000000003050ba>¨ inet_ioctl+0xde/0xf4 
>>  Ý<000000000029a8d0>¨ sock_ioctl+0x1cc/0x2dc 
>>  Ý<00000000000cb844>¨ do_ioctl+0xb8/0xcc 
>>  Ý<00000000000cb8f2>¨ vfs_ioctl+0x9a/0x3ec 
>>  Ý<00000000000cbc96>¨ sys_ioctl+0x52/0x7c 
>>  Ý<0000000000022484>¨ sysc_noemu+0x10/0x16 
>>  Ý<000002000010df12>¨ 0x2000010df12 
> 
> that's a network issue ;)
> 
>> 00000000002b3352 gives : include/linux/netdevice.h:819
>>
> 
> I have a feeling that we fixed this.  But there's no BUG at 2.6.23-mm1's
> include/linux/netdevice.h:819.  

but dev->header_ops is bogus. right ?

> How about setting CONFIG_DEBUG_BUGVERBOSE=y?

it is set :(

C.
 

