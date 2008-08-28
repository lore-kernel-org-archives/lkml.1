Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbYH1U3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbYH1U3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYH1U3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:29:37 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:43650 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYH1U3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:29:36 -0400
Message-ID: <48B70AAA.7010504@hp.com>
Date: Thu, 28 Aug 2008 13:29:30 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jmalicki@metacarta.com, andi@firstfloor.org, johnpol@2ka.mipt.ru,
       dada1@cosmosbay.com, denys@visp.net.lb, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
References: <21915755.1327801219904892242.JavaMail.root@ouachita>	<48B6E7D0.5070307@hp.com> <20080828.124251.149964287.davem@davemloft.net>
In-Reply-To: <20080828.124251.149964287.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The issue is the ordering of processing the requests.
> 
> So if request A arrived on interface 1 before request B arrived on
> interface 2, the trade described in A should be performed before the
> one in B.
> 
> This is not "arcance" as you seem to suppose it might be, but rather
> pretty clear fair handling or requests sent between trading desks.

Has the request "hit the trading system" when it hits the NIC, or when 
it hits the application executing the trade?  If the SEC calls for when 
it hits the NIC, then none of what is done today is really 
accurate/correct and one would need to start using NIC HW timestamps, 
synchronized with the host and the other NICs in the system no?

The way things are today, there really isn't much guarantee that hitting 
NIC 1 before NIC 2 will result in a driver-generated timestamp for the 
NIC 1 packet which is before the driver-generated timestamp for the NIC 
2 packet.  It will be luck of the interrupt coalescing interaction with 
other traffic on the NIC and/or polling out of NAPI right?

rick jones
