Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZLRRBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZLRRBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZLRRBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:01:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbZLRRA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:00:59 -0500
Message-ID: <4B2BB52A.7050103@redhat.com>
Date: Fri, 18 Dec 2009 19:00:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
References: <20091217084046.GA9804@basil.fritz.box> <1261039534.27920.67.camel@laptop> <20091217085430.GG9804@basil.fritz.box> <20091217144551.GA6819@linux.vnet.ibm.com> <20091217175338.GL9804@basil.fritz.box> <20091217190804.GB6788@linux.vnet.ibm.com> <20091217195530.GM9804@basil.fritz.box> <alpine.DEB.2.00.0912171356020.4640@router.home> <1261080855.27920.807.camel@laptop> <alpine.DEB.2.00.0912171439380.4640@router.home> <20091218051754.GC417@elte.hu>
In-Reply-To: <20091218051754.GC417@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 07:17 AM, Ingo Molnar wrote:
>
>> It is not about naming. The accessors hide the locking mechanism for
>> mmap_sem. Then you can change the locking in a central place.
>>
>> The locking may even become configurable later. Maybe an embedded solution
>> will want the existing scheme but dual quad socket may want a distributed
>> reference counter to avoid bouncing cachelines on faults.
>>      
> Hiding the locking is pretty much the worst design decision one can make.
>
>    

It does allow incremental updates.  For example if we go with range 
locks, the accessor turns into a range lock of the entire address space; 
users can be converted one by one to use their true ranges in order of 
importance.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

