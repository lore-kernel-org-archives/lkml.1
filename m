Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYENTFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYENTFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbYENTFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:05:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41969 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbYENTFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:05:30 -0400
Message-ID: <482B37F6.3080400@garzik.org>
Date: Wed, 14 May 2008 15:05:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Sage Weil <sage@newdream.net>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover,
 performance.
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net> <20080514135156.GA23131@2ka.mipt.ru> <20080514143105.GB14987@shareable.org>
In-Reply-To: <20080514143105.GB14987@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Look up "one-phase commit" or even "zero-phase commit".  (The
> terminology is cheating a bit.)  As I've understood it, all commit
> protocols have a step where each node guarantees it can commit if
> asked and node failure at that point does not invalidate the guarantee
> if the node recovers (if it can't maintain the guarantee, the node
> doesn't recover in a technical sense and a higher level protocol may
> reintegrate the node).  One/zero-phase commit extends that to
> guaranteeing a certain amounts and types of data can be written before
> it knows what the data is, so write messages within that window are
> sufficient for global commits.  Guarantees can be acquired
> asynchronously in advance of need, and can have time and other limits.
> These guarantees are no different in principle from the 1-bit
> guarantee offered by the "can you commit" phase of other commit
> protocols, so they aren't as weak as they seem.

For several common Paxos usages, you can obtain consensus guarantees 
well in advance of actually needing that guarantee, making the entire 
process quite a bit more async and parallel.

Sort of a "write ahead" for consensus.

	Jeff



