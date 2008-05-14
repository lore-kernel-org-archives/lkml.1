Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYENVdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYENVdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYENVc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:32:58 -0400
Received: from mail2.shareable.org ([80.68.89.115]:42015 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYENVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:32:57 -0400
Date: Wed, 14 May 2008 22:32:51 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Sage Weil <sage@newdream.net>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover, performance.
Message-ID: <20080514213251.GB23758@shareable.org>
Mail-Followup-To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Sage Weil <sage@newdream.net>, Jeff Garzik <jeff@garzik.org>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net> <20080514135156.GA23131@2ka.mipt.ru> <20080514143105.GB14987@shareable.org> <20080514150052.GA15826@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514150052.GA15826@2ka.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> If I understood that, client has to connect to all servers and send data
> there, so that after single reply things got committed. That is
> definitely not the issue, when there are lots of servers.
> 
> That can be the case if client connects to some gate server, which in
> turn broadcasts data further, that is how I plan to implement things at
> first.

Look up Bittorrent, and bandwidth diffusion generally.  Also look up
multicast trees.

Sometimes it's faster for a client to send to many servers; sometimes
it's faster to send fewer and have them relayed by intermediaries -
because every packet takes time to transmit, and network topologies
aren't always homogenous or symmetric.

There is no simple answer which is optimal for all networks.

> Another approach, which seems also intersting is leader election (per
> client), so that leader would broadcast all the data.

Leader election is part of standard Paxos too :-)

If you have a single data forwarder elected per client, then if one
client generates a lot of traffic, you concentrate a lot of traffic to
one network link and one CPU.  Sometimes it's better to elect several
leaders per client, and hash requests onto them.  You diffuse CPU and
traffic, but reduce opportunities to aggregate transactions into fewer
message.  It's an interesting problem, again probably with different
optimal results for different networks.

-- Jamie
