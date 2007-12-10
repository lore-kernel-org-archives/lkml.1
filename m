Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbXLJRzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbXLJRzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 12:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXLJRzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 12:55:08 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:64211 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXLJRzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 12:55:06 -0500
Message-ID: <475D7D70.5030502@nortel.com>
Date: Mon, 10 Dec 2007 11:54:56 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Chris Friesen" <cfriesen@nortel.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: "ip neigh show" not showing arp cache entries?
References: <475D7901.1040900@nortel.com>
In-Reply-To: <475D7901.1040900@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2007 17:55:00.0005 (UTC) FILETIME=[C85FF550:01C83B55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> 
> I'm seeing some strange behaviour on a 2.6.14 ppc64 system.  If I run 
> "ip neigh show" it prints out nothing, but if I run "arp" then I see the 
> other nodes on the local network.
> 
> 
> root@base0-0-0-5-0-11-1:/root> ip neigh show
> root@base0-0-0-5-0-11-1:/root> arp -n
> Address                  HWtype  HWaddress           Flags Mask    Iface
> 172.24.132.0             ether   00:01:AF:14:E8:DA   C    bond0
> 172.24.132.1                     (incomplete)    bond0
> 172.24.136.0             ether   00:C0:8B:07:B3:7E   C    bond0
> 172.24.132.4             ether   00:01:AF:14:E8:DA   C    bond0
> 172.24.132.2             ether   00:01:AF:14:E8:DA   C    bond0
> 
> 
> Any ideas what's going on here?

I've got some further information.  If I look for a specific address, it 
seems to work:

root@base0-0-0-5-0-11-1:/root> ip neigh show 172.24.136.0
172.24.136.0 dev bond0 lladdr 00:c0:8b:07:b3:7e REACHABLE


In the above scenario, the arp cache lists the device as reachable via 
bond0.  If I search the arp cache to see whether the address is 
reachable from one of bond0's slave devices, should it come back 
positive or negative?

Chris
