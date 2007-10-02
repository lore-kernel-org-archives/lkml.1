Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbXJCMZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbXJCMZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbXJCMZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:25:02 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:44036 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754229AbXJCMZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:25:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fmxAU+jAMm846eQJSJNoXNC8aMvv5Tjo8zmdGMes0BpeNjSSrzXkfE+I/cAOoP+P/abRt3uaYbhfeRzkuYkJNe/N90LPY4BMesSt+5O2xBhmFsDpztM1fvV2RnDOsiCSQGK9FtjQAFd4phK0ZzoyQZlSYMd2zFlprTnlsWmwRSA=  ;
X-YMail-OSG: h6D889oVM1kYX_V96WwLzhYZga0Tq4BXtaLO3sgMBDcNkOnb8xxrW51gztlQAdHZoTRVr1eqrQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Wed, 3 Oct 2007 05:53:27 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200710030525.29735.nickpiggin@yahoo.com.au> <20071003051438.e1371e99.pj@sgi.com>
In-Reply-To: <20071003051438.e1371e99.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030553.27822.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 22:14, Paul Jackson wrote:
> > These are what I'm worried about, and things like kswapd, pdflush,
> > could definitely use a huge amount of CPU.
> >
> > If you are interested in hard partitioning the system, you most
> > definitely want these things to be balanced across the non-isolated
> > CPUs.
>
> But these guys are pinned anyway (or else they would already be moved
> into a smaller load balanced cpuset), so why waste time load balancing
> what can't move?

They're not pinned (kswapds are pinned to a node, but still). pdflush
is not pinned at all and can be dynamically created and destroyed. Ditto
for kjournald, as well as many others.

Basically: it doesn't feel like a satisfactory solution to brush these under
the carpet.


> And on some of the systems I care about, we don't want to load balance
> these guys; rather we go to great lengths to see that they don't run at
> all when we don't want them to.

Most smaller realtime partitioned systems will want to, I'd expect.

