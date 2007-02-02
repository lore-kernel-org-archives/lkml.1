Return-Path: <linux-kernel-owner+w=401wt.eu-S1423178AbXBBHpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423178AbXBBHpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423204AbXBBHpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:45:38 -0500
Received: from mail.suse.de ([195.135.220.2]:46334 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423178AbXBBHph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:45:37 -0500
From: Andi Kleen <ak@suse.de>
To: suparna@in.ibm.com
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion system calls
Date: Fri, 2 Feb 2007 08:45:27 +0100
User-Agent: KMail/1.9.5
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170359406.6151.55.camel@lade.trondhjem.org> <20070202071916.GA17449@in.ibm.com>
In-Reply-To: <20070202071916.GA17449@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020845.27481.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Isn't that kind of information supposed to be captured in nfs_open_context ?
> Which is associated with the open file instance ...

Or a refcounted struct cred. Which would be needed for strict POSIX thread
semantics likely anyways. But there never was enough incentive to go down
that path and it would be likely somewhat slow.

> 
> I know this has been a traditional issue with network filesystems, and I
> haven't kept up with the latest code and decisions in that respect, but how
> would you do background writeback if there is an assumption of running in
> the context of the original submitter ?

AFAIK (Trond will hopefully correct me if I'm wrong) in the special case of 
NFS there isn't much problem because the server does the (passive) authentication
and there is no background writeback from server to client. The client just 
does the usual checks at open time and then forgets about it. The server
threads don't have own credentials but just check those of others.

I can't think of any cases where you would need to do authentication
in the client for every read() or write() 

Overall the arguments for reusing current don't seem to be strong to me.

-Andi
