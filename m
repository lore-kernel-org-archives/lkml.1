Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYENW0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYENW0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYENW0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:26:35 -0400
Received: from cobra.newdream.net ([66.33.216.30]:39552 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYENW0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:26:34 -0400
Date: Wed, 14 May 2008 15:26:31 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions,
 failover, performance.
In-Reply-To: <482B5E6F.4020204@garzik.org>
Message-ID: <Pine.LNX.4.64.0805141516540.23143@cobra.newdream.net>
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org>
 <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net>
 <482B2E50.2030601@garzik.org> <Pine.LNX.4.64.0805141247180.23143@cobra.newdream.net>
 <482B5E6F.4020204@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Jeff Garzik wrote:
> Sage Weil wrote:
> > You mean if, say, some verifiable metadata or a trusted third party stores
> > that checksum?  Sure.  This is just pushing the what-has-committed
>
> Yes.
>
> > information to some other party, though, who will presumably face the same
> > problem of requiring a majority for verifiable correctness.  This is more or
> > less what most people do in practice... using Paxos for critical state and
> > piggybacking the rest of the system's consistency off of that.
>
> More like receiving a guarantee of consensus (just like any signature on
> data), while only needing to be able to communicate with a single node.

It's the 'single node' part that concerns me.  As long as that node is 
ensuring there is consensus behind the scenes before handing out said 
signature.  Otherwise you can't be sure you're not getting an old 
signature for old data..

This is more or less what I ended up doing.  Since the workload is 
mostly-read, the paxos leader gives non-leaders leases to process reads in 
parallel, and new elections or state changes wait if necessary to ensure 
old leases are revoked or expire before any new leases on new values are 
issued.

sage
