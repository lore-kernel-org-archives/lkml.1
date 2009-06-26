Return-Path: <linux-kernel-owner+w=401wt.eu-S1761399AbZFZTgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399AbZFZTgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZFZTgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:36:32 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:47353 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZFZTgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:36:31 -0400
Message-ID: <4A452300.5080507@gmail.com>
Date: Fri, 26 Jun 2009 21:35:28 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: jolsa@redhat.com
CC: David Miller <davem@davemloft.net>, davidel@xmailserver.org,
       oleg@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       fbl@redhat.com, nhorman@redhat.com, htejun@gmail.com
Subject: Re: [PATCH] net: fix race in the receive/select
References: <alpine.DEB.1.10.0906261018580.16400@makko.or.mcafeemobile.com>	<20090626145027.GA6534@redhat.com>	<alpine.DEB.1.10.0906261111230.16400@makko.or.mcafeemobile.com> <20090626.111738.141246987.davem@davemloft.net>
In-Reply-To: <20090626.111738.141246987.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 26 Jun 2009 21:35:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Davide Libenzi <davidel@xmailserver.org>
> Date: Fri, 26 Jun 2009 11:12:15 -0700 (PDT)
> 
>> On Fri, 26 Jun 2009, Oleg Nesterov wrote:
>>
>>> Perhaps we can add
>>>
>>> 	void sock_poll_wait(struct file *file, struct sock *sk, poll_table *pt)
>>> 	{
>>> 		if (pt) {
>>> 			poll_wait(file, sk->sk_sleep, pt);
>>> 			/*
>>> 			 * fat comment
>>> 			 */
>>> 			smp_mb(); // or smp_mb__after_unlock();
>>> 		}
>>> 	}
>> That'd be fine IMHO. Are DaveM and Eric OK?
> 
> No objections from me.

Very good :)

Jiri, please respin a patch with this idea from Oleg

(We'll have to check all calls to poll_wait() in net tree)

Thanks everybody

