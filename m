Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbYENSYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbYENSYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYENSYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:24:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41129 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbYENSYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:24:20 -0400
Message-ID: <482B2E50.2030601@garzik.org>
Date: Wed, 14 May 2008 14:24:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sage Weil <sage@newdream.net>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover,
 performance.
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil wrote:
>>> What is your opinion of the Paxos algorithm?
>> It is slow. But it does solve failure cases.
> 
> For writes, Paxos is actually more or less optimal (in the non-failure 
> cases, at least).  Reads are trickier, but there are ways to keep that 
> fast as well.  FWIW, Ceph extends basic Paxos with a leasing mechanism to 
> keep reads fast, consistent, and distributed.  It's only used for cluster 
> state, though, not file data.
> 
> I think the larger issue with Paxos is that I've yet to meet anyone who 
> wants their data replicated 3 ways (this despite newfangled 1TB+ disks not 
> having enough bandwidth to actualy _use_ the data they store).  

I've seen clusters in the field that planned for this -- they don't want 
to lose their data.


> Similarly, if only 1 out of 3 replicas is surviving, most people want to 
> be able to read their data, while Paxos demands a majority to ensure it is 
> correct.

This isn't necessarily true -- it's quite easy for most applications to 
come up with an alternate method for ensuring correctness of retrieved 
data, if one assumes Paxos consensus was achieved during the write-data 
phase earlier in time.  Checksumming is a common solution, but not the 
only one.  Domain- or app-specific solution, as noted, of course.

Overall, reads can be optimized outside of Paxos in many ways.


> (This is why Paxos is typically used only for critical cluster 
> configuration/state, not regular data.)

Yep, I'm working on a config daemon a la Chubby or zookeeper, based on 
Paxos, that does just this.  :)

	Jeff


