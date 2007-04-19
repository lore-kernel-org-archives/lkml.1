Return-Path: <linux-kernel-owner+w=401wt.eu-S637751AbXDSM5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637751AbXDSM5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 08:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637757AbXDSM5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 08:57:22 -0400
Received: from mx12.go2.pl ([193.17.41.142]:48660 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S637751AbXDSM5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 08:57:21 -0400
Date: Thu, 19 Apr 2007 15:02:57 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: David Miller <davem@davemloft.net>
Cc: xemul@sw.ru, akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Set a separate lockdep class for neighbour table's proxy_queue
Message-ID: <20070419130256.GA13475@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417.124610.63508619.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-04-2007 21:46, David Miller wrote:
> From: Pavel Emelianov <xemul@sw.ru>
> Date: Mon, 16 Apr 2007 16:08:25 +0400
> 
>> Otherwise the following calltrace will lead to a wrong
>> lockdep warning:
>>
>>   neigh_proxy_process()
>>     `- lock(neigh_table->proxy_queue.lock);
>>   arp_redo /* via tbl->proxy_redo */
>>   arp_process
>>   neigh_event_ns
>>   neigh_update
>>   skb_queue_purge
>>     `- lock(neighbor->arp_queue.lock);
>>
>> This is not a deadlock actually, as neighbor table's proxy_queue
>> and the neighbor's arp_queue are different queues.
>>
>> Lockdep thinks there is a deadlock as both queues are initialized
>> with skb_queue_head_init() and thus have a common class.
> 
> Patch applied, thank you.
> 
> Please provide a proper "Signed-off-by: " line in future patch
...

And I'd suggest to attach a lockdep's log, or some reference to
it, for some born unbelievers...

Regards,
Jarek P.
