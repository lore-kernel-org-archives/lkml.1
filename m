Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbXLLQWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbXLLQWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbXLLQVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:21:49 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:36218 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXLLQVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:21:45 -0500
Message-ID: <47600A6E.8000202@nortel.com>
Date: Wed, 12 Dec 2007 10:21:02 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: "ip neigh show" not showing arp cache entries?
References: <475D7901.1040900@nortel.com> <475D7D70.5030502@nortel.com>
In-Reply-To: <475D7D70.5030502@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2007 16:21:06.0088 (UTC) FILETIME=[FF1FF280:01C83CDA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I retested it on an x86 machine and am seeing similar problems.

First, "arp" gives the arp table as expected:

root@typhoon-base-unit0:/tftpboot/cnp/0-0-5-0/0-0-5-0> arp -n
Address                  HWtype  HWaddress           Flags Mask 
    Iface
172.24.0.9               ether   00:03:CC:51:06:5E   C 
    bond0
10.41.18.101             ether   00:0E:0C:5E:95:BD   C 
    eth6
172.24.137.0             ether   00:C0:8B:08:E4:88   C 
    bond0
172.24.136.0             ether   00:C0:8B:07:B3:7E   C 
    bond0
10.41.18.1               ether   00:00:5E:00:01:01   C 
    eth6
172.24.0.5               ether   00:01:AF:15:E0:6A   C 
    bond0
172.24.0.13              ether   00:0E:0C:85:FD:D2   C 
    bond0
172.24.0.3               ether   00:01:AF:14:C8:CC   C 
    bond0
172.24.132.1             ether   00:01:AF:14:E9:88   C 
    bond0
172.24.0.7               ether   00:07:E9:41:4B:B4   C 
    bond0
192.168.24.81            ether   00:01:AF:14:E9:8A   C 
    bond2

"ip neigh show" gives nothing, but if I search for specific addresses 
from the arp table listing they show up:

root@typhoon-base-unit0:/tftpboot/cnp/0-0-5-0/0-0-5-0> ip neigh show
root@typhoon-base-unit0:/tftpboot/cnp/0-0-5-0/0-0-5-0> ip neigh show 
172.24.0.9
172.24.0.9 dev bond0 lladdr 00:03:cc:51:06:5e DELAY
root@typhoon-base-unit0:/tftpboot/cnp/0-0-5-0/0-0-5-0> ip neigh show 
10.41.18.101
10.41.18.101 dev eth6 lladdr 00:0e:0c:5e:95:bd REACHABLE
root@typhoon-base-unit0:/tftpboot/cnp/0-0-5-0/0-0-5-0> ip neigh show 
172.24.137.0
172.24.137.0 dev bond0 lladdr 00:c0:8b:08:e4:88 REACHABLE


Is this expected behaviour?

Thanks,

Chris
