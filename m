Return-Path: <linux-kernel-owner+w=401wt.eu-S1030319AbXHPCUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319AbXHPCUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936522AbXHPCUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:20:01 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:63136 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936156AbXHPCT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:19:58 -0400
Message-ID: <46C3B40D.3010909@nortel.com>
Date: Wed, 15 Aug 2007 20:18:53 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Satyam Sharma <satyam@infradead.org>, Christoph Lameter <clameter@sgi.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in> <18115.35524.56393.347841@cargo.ozlabs.ibm.com> <Pine.LNX.4.64.0708151725130.10497@schroedinger.engr.sgi.com> <20070816003948.GY9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151740570.10497@schroedinger.engr.sgi.com> <20070816005348.GA9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151757400.11196@schroedinger.engr.sgi.com> <20070816011414.GC9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151839140.11520@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0708160730590.24380@enigma.security.iitk.ac.in> <20070816020851.GA30809@gondor.apana.org.au>
In-Reply-To: <20070816020851.GA30809@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Aug 2007 02:18:57.0409 (UTC) FILETIME=[CCF0E710:01C7DFAB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:

> But I have to say that I still don't know of a single place
> where one would actually use the volatile variant.

Given that many of the existing users do currently have "volatile", are 
you comfortable simply removing that behaviour from them?  Are you sure 
that you will not introduce any issues?

Forcing a re-read is only a performance penalty.  Removing it can cause 
behavioural changes.

I would be more comfortable making the default match the majority of the 
current implementations (ie: volatile semantics).  Then, if someone 
cares about performance they can explicitly validate the call path and 
convert it over to the non-volatile version.

Correctness before speed...

Chris
