Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbZDTShk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbZDTShk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZDTSh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:37:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48727 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbZDTSh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:37:27 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: stefan novak <lms.brubaker@gmail.com>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: bond interface arp, vlan and trunk / network question
In-reply-to: <49ECBBF0.80202@cosmosbay.com>
References: <1ef444010904201050g72651387se3feca3fbd68ce30@mail.gmail.com> <49ECBBF0.80202@cosmosbay.com>
Comments: In-reply-to Eric Dumazet <dada1@cosmosbay.com>
   message dated "Mon, 20 Apr 2009 20:16:16 +0200."
X-Mailer: MH-E 8.0.3; nmh 1.3-RC3; GNU Emacs 22.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Apr 2009 11:37:31 -0700
Message-ID: <30257.1240252651@death.nxdomain.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> wrote:

>stefan novak a écrit :
>> Hello list,
>> 
>> I've got a Problem with my bladecenter and bond interfaces.
>> My Server has 2 interface, each on a seperate switch. Each
>> serverinterface is connected via a trunk to one of the switches.
>> Each switch has a trunk to stacked-backbone switch.
>> 
>> nic1 --trunk--> bladesw1 --trunk--> backbone switch
>> nic2 --trunk--> bladesw2 --trunk--> backbone switch
>> 
>> So far vlan and trunking works as expected. But if one trunk
>> connection from a bladeswitch to the backbone switch is down the
>> mii-tool cant recognize this.
>
>What is the exact problem on this one ?

	This is the expected behavior, the external switch to
bladecenter switch (ESM) link status does not affect the ESM to blade
link status.

	Unless... your ESM supports "trunk failover."  I believe the
Cisco ESMs do, I'm not sure about others.  With trunk failover enabled,
loss of link on an external switch port will in turn drop link on the
corresponding internal switch ports.  There is a long-ish delay for
this, on the order of 750 ms, as I recall.

>> I tried to use an arp target on the backbone switch to check the
>> connection state.
>> 
>> Now i'm running into problems. :(
>> My bladesw1 is configured with a trunk and a private vlan id of 600.
>> On the backbone switch is a server in the vlan 600 connected, but i
>> can't get an arp request.
>> 
>> What can be the problem, or is it possible to add a vlan tag on the arp check?
>> 
>
>What driver is in use on your NIC interface ?
>
>Could you post your bonding settings ?
>
>cat /proc/net/bonding/bond0

	Sufficiently recent versions of bonding should VLAN tag the ARP
probes, provided you are using a VLAN device configured above the bond.
My recollection is that VLAN tagging of ARP probes was added about three
years ago.

	If the switch port is configured as native to a VLAN, then it
should tag everything coming in.

	As Eric asks, what are you running?

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
