Return-Path: <linux-kernel-owner+w=401wt.eu-S965221AbXHJTzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965221AbXHJTzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940230AbXHJTyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:54:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938642AbXHJTyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:54:40 -0400
Message-ID: <46BCC26B.6080600@redhat.com>
Date: Fri, 10 Aug 2007 15:54:19 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
References: <46BB46B2.60808@redhat.com> <20070809134150.GA14890@shell.boston.redhat.com> <2708.1186737826@redhat.com>
In-Reply-To: <2708.1186737826@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Chris Snook <csnook@redhat.com> wrote:
> 
>> To head off the criticism, I admit this is an oversimplification, and true
>> busy-waiters should be using cpu_relax(), which contains a barrier.
> 
> Why would you want to use cpu_relax()?  That's there to waste time efficiently,
> isn't it?  Shouldn't you be using smp_rmb() or something like that?
> 
> David

cpu_relax() contains a barrier, so it should do the right thing.  For 
non-smp architectures, I'm concerned about interacting with interrupt 
handlers.  Some drivers do use atomic_* operations.

	-- Chris
