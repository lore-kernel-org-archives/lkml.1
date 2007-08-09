Return-Path: <linux-kernel-owner+w=401wt.eu-S966645AbXHIRA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966645AbXHIRA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966196AbXHIRAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:00:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966024AbXHIRAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:00:15 -0400
Message-ID: <46BB46B2.60808@redhat.com>
Date: Thu, 09 Aug 2007 12:54:10 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
CC: netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
References: <20070809134150.GA14890@shell.boston.redhat.com>
In-Reply-To: <20070809134150.GA14890@shell.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> From: Chris Snook <csnook@redhat.com>
> 
> Make atomic_read() volatile on frv.  This ensures that busy-waiting
> for an interrupt handler to change an atomic_t won't get compiled to an
> infinite loop, consistent with SMP architectures.

To head off the criticism, I admit this is an oversimplification, and true 
busy-waiters should be using cpu_relax(), which contains a barrier.  As 
discussed in recent threads, there are other cases which can be optimized by 
removing the need for a barrier, and having behavior consistent with 
architectures where the benefit is more profound is also valuable.

	-- Chris
