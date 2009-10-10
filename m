Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZJJJGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZJJJGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 05:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZJJJGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 05:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbZJJJGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 05:06:10 -0400
Message-ID: <4AD04E50.7060001@redhat.com>
Date: Sat, 10 Oct 2009 11:05:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] sched: add notifier for process migration
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop>	 <4ACFBC98.4070701@goop.org> <1255158863.7866.25.camel@twins>
In-Reply-To: <1255158863.7866.25.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2009 09:14 AM, Peter Zijlstra wrote:
> Why not do something like:
>
>      struct {
> 	u64 tsc;
> 	u32 aux;
>      } tscp = rdtscp();
>
>      local_time_info = timeinfo[tscp_cpu(tscp)];
>
>      /* yay, consistent tsc and timeinfo !! */
>    

First, not all processors support rdtscp.  Second, timeinfo might change 
at any time due to cpu frequency changes or the entire cpu being 
migrated, so we need to loop in any case.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

