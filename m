Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbXHUKkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbXHUKkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbXHUKkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:40:06 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:50393 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbXHUKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:40:04 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [accounting regression since rc1]  scheduler updates
Date: Tue, 21 Aug 2007 12:39:44 +0200
User-Agent: KMail/1.9.7
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
References: <20070812163225.GA11996@elte.hu> <1187687476.7623.8.camel@localhost> <20070821093434.GB12025@elte.hu>
In-Reply-To: <20070821093434.GB12025@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211239.44657.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 21. August 2007 schrieb Ingo Molnar:
> Wouldnt it be more consistent if a virtual box would not show any 
> dependency on external load? (i.e. it would slow down all of its 
> internal functionality transparently, without exposing it via /proc. The 
> only way to observe that would be the TOD interfaces: gettimeofday and 
> real-time clock driven POSIX timers. Even timer_list could be driven via 
> virtual time - although that would probably break user expectations, 
> right?) Or would accounting-in-virtual-time break user expectations too? 
> (most of the other hypervisors let guests account in virtual time.)

Most hypervisors let guest account in virtual time because this requires no 
code change. We had that in the past as well. But now we have lots of 
customers that rely on a different accounting model. Before 
CONFIG_VIRT_CPU_ACCOUNTING we got this model of top showing 99% of cpu used, 
even if the hypervisor gives us 20% of the physical one.  We actually want to 
show that this process gets only 19.8% of a real cpu for several reasons:
- people do workload management based on used cycles
- people/departments pay money based on used cycles
- If your physical cpu has to much load, you want to identify processes by 
physical cpu usage

There are even some vendors that claimed that Linux accouting was completely 
broken and useless on s390 and people should use their vendor tool to get the 
right numbers. While these tools still have important features 
CONFIG_VIRT_CPU_ACCOUNTING fixed at least the "broken" parts. 


Christian
