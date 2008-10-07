Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbYJGQnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbYJGQnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYJGQnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:43:18 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:61946 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbYJGQnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:43:17 -0400
Date: Tue, 07 Oct 2008 11:43:04 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
In-reply-to: <48EB5D28.7000503@cosmosbay.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Benny Amorsen <benny+usenet@amorsen.dk>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, shemminger@vyatta.com,
       paulmck@linux.vnet.ibm.com
Message-id: <48EB9198.1090605@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20081006185026.GA10383@minyard.local>
 <48EA8197.6080502@cosmosbay.com>
 <20081006.144002.56418911.davem@davemloft.net>
 <48EAF29D.8050203@cosmosbay.com> <m37i8k3hv1.fsf@ursa.amorsen.dk>
 <48EB5D28.7000503@cosmosbay.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
>
> (2 weeks ago, Corey mentioned a 10x increase on UDP throughput on a 
> 16-way machine,
> that sounds promising)
Just to be clear, that was 10x with preempt RT, which converts rwlocks 
into PI mutexes.  So 16 processors going for the same lock is pretty ugly.

Under heavy loads there is also a writer starvation problem, I believe 
in non-RT.  You can't actually create or destroy a UDP socket when the 
load is high because there's always a reader holding the lock.  RCU also 
solves that problem.

-corey

