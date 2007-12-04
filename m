Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbXLDR1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbXLDR1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbXLDR1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:27:38 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:38150 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbXLDR1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:27:37 -0500
Message-ID: <47558DFC.5050601@nortel.com>
Date: Tue, 04 Dec 2007 11:27:24 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       bonding-devel@lists.sourceforge.net
Subject: when using arp monitoring with bonding, why use broadcast arps?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Dec 2007 17:27:28.0698 (UTC) FILETIME=[F1A401A0:01C8369A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We have a network with a number of nodes using bonding with arp 
monitoring.  The arp interval is set to 100ms.

Unfortunately, the bonding code sends the arp packets to the hardware 
broadcast address, which means that the number of these arp packets seen 
by each node goes up with the number of nodes on the network.

One of the nodes has a fairly low-powered cpu and handles most things in 
microengine code, but arp packets get handled in software.  All these 
broadcast arps slow this node down noticeably.

Is there any particular reason why the bonding code couldn't use unicast 
arp packets if the "arp_ip_target" has a valid entry in the sender's arp 
table?

Thanks,

Chris
