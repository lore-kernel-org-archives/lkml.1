Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbYENViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbYENViS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYENViE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:38:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53661 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYENViB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:38:01 -0400
Message-ID: <482B5BB6.3040308@garzik.org>
Date: Wed, 14 May 2008 17:37:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Sage Weil <sage@newdream.net>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover,
 performance.
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net> <20080514135156.GA23131@2ka.mipt.ru> <20080514143105.GB14987@shareable.org> <20080514150052.GA15826@2ka.mipt.ru> <20080514213251.GB23758@shareable.org>
In-Reply-To: <20080514213251.GB23758@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> If you have a single data forwarder elected per client, then if one
> client generates a lot of traffic, you concentrate a lot of traffic to
> one network link and one CPU.  Sometimes it's better to elect several
> leaders per client, and hash requests onto them.  You diffuse CPU and
> traffic, but reduce opportunities to aggregate transactions into fewer
> message.  It's an interesting problem, again probably with different
> optimal results for different networks.


Definitely.  "several leaders" aka partitioning is also becoming 
increasing paired with efforts at enhancing locality of reference.  Both 
Google and Amazon sort their distributed tables lexographically, which 
[ideally] results in similar data being stored near each other.

A bit of an improvement over partitioning-by-hash, anyway, for some 
workloads.

	Jeff


