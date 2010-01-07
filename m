Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592Ab0AGXwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab0AGXwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476Ab0AGXwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:52:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab0AGXwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:52:21 -0500
Message-ID: <4B467388.809@redhat.com>
Date: Thu, 07 Jan 2010 18:51:36 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
References: <20100104182429.833180340@chello.nl>  <20100104182813.753545361@chello.nl>  <20100105054536.44bf8002@infradead.org>  <alpine.DEB.2.00.1001050916300.1074@router.home>  <20100105192243.1d6b2213@infradead.org>  <alpine.DEB.2.00.1001071007210.901@router.home>  <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain> <1262884960.4049.106.camel@laptop> <alpine.LFD.2.00.1001070934060.7821@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001070934060.7821@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2010 12:36 PM, Linus Torvalds wrote:
> On Thu, 7 Jan 2010, Peter Zijlstra wrote:
>>
>> Right, supposing we can make this speculative fault stuff work, then we
>> can basically reduce the mmap_sem usage in fault to:
>>
>>    - allocating new page tables
>>    - extending the growable vmas
>>
>> And do everything else without holding it, including zeroing and IO.
>
> Well, I have yet to hear a realistic scenario of _how_ to do it all
> speculatively in the first place, at least not without horribly subtle
> complexity issues. So I'd really rather see how far we can possibly get by
> just improving mmap_sem.

I would like to second this sentiment.  I am trying to make the
anon_vma and rmap bits more scalable for multi-process server
workloads and it is quite worrying how complex locking already
is.

-- 
All rights reversed.
