Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbYLDXJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbYLDXJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYLDXJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:09:23 -0500
Received: from colobus.isomerica.net ([216.93.242.10]:44496 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYLDXJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:09:22 -0500
Message-ID: <4938631F.7010004@isomerica.net>
Date: Thu, 04 Dec 2008 18:09:19 -0500
From: =?UTF-8?B?RGFuIE5vw6k=?= <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Page alloc failures under network/disk IO load
References: <20081203222750.391e8890@tuna> <1228378983.5092.7.camel@twins> <1228380128.5092.15.camel@twins> <20081204135443.7c24234a@rockhopper.limebrokerage.com> <20081204224021.GA323@electric-eye.fr.zoreil.com>
In-Reply-To: <20081204224021.GA323@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 0.95.7
OpenPGP: url=http://isomerica.net/~dpn/gpgkey
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Dan Noé <dpn@isomerica.net> :
> [...]
>> I'm a bit confused because on another system (2.6.26.3) I never see
>> messages like this despite having the same amount of physical RAM in
>> each.  The 2.6.26.3 system is also under more active use, and has more
>> userspace memory usage.  On that system:
> 
> Does this system use the same network card ?

Nope, good point :)  The system experiencing the allocation failures is
using an rtl8169 gigabit NIC (at 1gbps), the 2.6.26.3 system is on a
100M connection with a gigabit Broadcom BCM5721 / tg3.

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)

04:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721
Gigabit Ethernet PCI Express (rev 11)

I can see how this could account for different behavior, although
presumably both drivers are calling __netdev_alloc_skb.

Cheers,
Dan

-- 
                    /--------------- - -  -  -   -   -
                    |  Dan Noé
                    |  http://isomerica.net/~dpn/
