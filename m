Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYJFXIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYJFXIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYJFXId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:08:33 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:48493 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYJFXIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:08:32 -0400
Date: Mon, 06 Oct 2008 18:08:09 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
In-reply-to: <20081006.144002.56418911.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Message-id: <48EA9A59.1090306@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20081006185026.GA10383@minyard.local>
 <48EA8197.6080502@cosmosbay.com> <20081006.144002.56418911.davem@davemloft.net>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Mon, 06 Oct 2008 23:22:31 +0200
>
>   
>> Me wondering what impact this synchronize_rcu() can have on mono-threaded
>> VOIP applications using lot of UDP sockets. What is the maximum delay of
>> this function ?
>>     
>
> The cost is enormous, we really can't use it here.
>
> I have a patch that did top-level socket destruction using RCU,
> and that didn't use synchronize_rcu(), and that killed connection
> rates by up to %20.
>
> I can only imagine what the cost would be if I had to add such a call
> in there.
>
> Really, I can't consider these changes seriously, as-is.
>
>   
Would using SLAB_DESTROY_BY_RCU be ok, or would that be too expensive?

-corey
