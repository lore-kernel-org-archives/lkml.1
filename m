Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbYHATYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbYHATYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbYHATXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:23:51 -0400
Received: from mail.fieldses.org ([66.93.2.214]:47062 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbYHATXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:23:50 -0400
Date: Fri, 1 Aug 2008 15:23:43 -0400
To: Neil Brown <neilb@suse.de>, Michael Shuey <shuey@purdue.edu>,
       Shehjar Tikoo <shehjart@cse.unsw.edu.au>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, rees@citi.umich.edu, aglo@citi.umich.edu
Subject: Re: high latency NFS
Message-ID: <20080801192343.GJ7764@fieldses.org>
References: <200807241311.31457.shuey@purdue.edu> <20080730192110.GA17061@fieldses.org> <4890DFC7.3020309@cse.unsw.edu.au> <200807302235.50068.shuey@purdue.edu> <20080731031512.GA26203@fieldses.org> <18577.25513.494821.481623@notabene.brown> <20080801072320.GE6201@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801072320.GE6201@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 05:23:20PM +1000, Dave Chinner wrote:
> Having implemented the second option on a different NUMA aware
> OS and NFS server, I can say that it isn't that complex, nor that
> hard to screw up.
> 
> 	1. spawn a new thread only if all NFSDs are busy and there
> 	   are still requests queued to be serviced.
> 	2. rate limit the speed at which you spawn new NFSD threads.
> 	   About 5/s per node was about right.
> 	3. define an idle time for each thread before they
> 	   terminate. That is, is a thread has not been asked to
> 	   do any work for 30s, exit.
> 	4. use the NFSD thread pools to allow per-pool independence.

Actually, I lost you on #4.  You mean that you apply 1-3 independently
on each thread pool?  Or something else?

--b.
