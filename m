Return-Path: <linux-kernel-owner+w=401wt.eu-S1763789AbYENTLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763789AbYENTLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbYENTLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:11:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39038 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbYENTLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:11:17 -0400
Message-ID: <482B394F.6070700@garzik.org>
Date: Wed, 14 May 2008 15:11:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sage Weil <sage@newdream.net>
CC: Jamie Lokier <jamie@shareable.org>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover,
 performance.
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net> <20080514140908.GA14987@shareable.org> <Pine.LNX.4.64.0805140900460.23143@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.0805140900460.23143@cobra.newdream.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil wrote:
> On Wed, 14 May 2008, Jamie Lokier wrote:
>> In that model, neighbour sensing is used to find the largest coherency
>> domains fitting a set of parameters (such as "replicate datum X to N
>> nodes with maximum comms latency T").  If the parameters are able to
>> be met, quorum gives you the desired robustness in the event of
>> node/network failures.  During any time while the coherency parameters
>> cannot be met, the robustness reduces to the best it can do
>> temporarily, and recovers when possible later.  As a bonus, you have
>> some timing guarantees if they are more important.
> 
> Anything that silently relaxes consistency like that scares me.  Does 
> anybody really do that in practice?

Well, there's Amazon Dynamo, a distributed system that places most 
importance on writes succeeding, if inconsistent.  They choose to relax 
consistency up front, and on the backend absorb the cost of merging 
multiple versions of objects:

http://www.allthingsdistributed.com/2007/10/amazons_dynamo.html
(full paper)

	Jeff



