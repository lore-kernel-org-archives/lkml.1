Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbXGYPhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbXGYPhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbXGYPhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:37:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbXGYPhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:37:23 -0400
Message-ID: <46A76E10.7090004@redhat.com>
Date: Wed, 25 Jul 2007 11:36:48 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Eric St-Laurent <ericstl34@sympatico.ca>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Fengguang Wu <fengguang.wu@gmail.com>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
References: <20070721210005.000228000@chello.nl>	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>	 <20070722081010.GA6317@mail.ustc.edu.cn>	 <1185093236.6344.87.camel@localhost.localdomain>	 <46A46E4B.7050007@yahoo.com.au> <1185338106.7105.44.camel@perkele>	 <46A6DD7F.1050505@yahoo.com.au> <1185344325.7105.91.camel@perkele>	 <46A6F732.3080905@yahoo.com.au> <1185349711.7105.154.camel@perkele>
In-Reply-To: <1185349711.7105.154.camel@perkele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric St-Laurent wrote:
> On Wed, 2007-25-07 at 17:09 +1000, Nick Piggin wrote:
> 
>> A new list could be a possibility. One problem with adding lists is just
>> trying to work out how to balance scanning rates between them, another
>> problem is CPU overhead of moving pages from one to another... 
> 
> Disk sizes seem to increase more rapidly that the ability to read them
> quickly.  Fortunately the processing power increase greatly too.
> 
> It may be a good idea to spend more CPU cycles to better decide how the
> VM should juggle with this data. We've got to keep those multi-cores cpu
> busy.

Agreed, up to a level.  You cannot let hundreds of gigabytes
worth of memory sit around with (stale) accessed bits set,
and then have to scan millions of pages all at once when free
memory finally runs low.

The amount of CPU time spent in the pageout code at any point
in time needs to be limited.

> If we don't see much work on this area it's surely because it's really
> not a problem anymore for most workloads. Database have their own cache
> management and disk scheduling, file servers just add more ram or
> processors, etc.

It is a really big problem for some (fairly common) workloads,
though.

One of the main reasons there has been little activity in this
area upstream is that nobody (at least, nobody I talked to)
had real fixes in mind for the problem.

All we had were workarounds for RHEL, not the kind of real
fixes that are interesting for upstream.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
