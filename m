Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYLEEJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYLEEJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 23:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYLEEI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 23:08:58 -0500
Received: from main.gmane.org ([80.91.229.2]:38961 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbYLEEI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 23:08:57 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Page alloc failures under network/disk IO load
Date: Thu, 04 Dec 2008 22:08:43 -0600
Message-ID: <4938A94B.3080801@shaw.ca>
References: <20081203222750.391e8890@tuna> <1228378983.5092.7.camel@twins> <1228380128.5092.15.camel@twins> <20081204135443.7c24234a@rockhopper.limebrokerage.com> <20081204224021.GA323@electric-eye.fr.zoreil.com> <4938631F.7010004@isomerica.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Francois Romieu <romieu@fr.zoreil.com>,
       Peter Zijlstra <peterz@infradead.org>
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <4938631F.7010004@isomerica.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Noé wrote:
> Francois Romieu wrote:
>> Dan Noé <dpn@isomerica.net> :
>> [...]
>>> I'm a bit confused because on another system (2.6.26.3) I never see
>>> messages like this despite having the same amount of physical RAM in
>>> each.  The 2.6.26.3 system is also under more active use, and has more
>>> userspace memory usage.  On that system:
>> Does this system use the same network card ?
> 
> Nope, good point :)  The system experiencing the allocation failures is
> using an rtl8169 gigabit NIC (at 1gbps), the 2.6.26.3 system is on a
> 100M connection with a gigabit Broadcom BCM5721 / tg3.
> 
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
> 
> 04:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721
> Gigabit Ethernet PCI Express (rev 11)
> 
> I can see how this could account for different behavior, although
> presumably both drivers are calling __netdev_alloc_skb.

The Realtek driver is doing an order 1 allocation (an 8KB chunk). That 
is more likely to fail than an order 0. Are you using jumbo frames or 
higher than 1500 byte MTU on the network?

