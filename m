Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971Ab0ARLCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0ARLCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261Ab0ARLCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:02:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab0ARLCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:02:16 -0500
Message-ID: <4B543F93.3060509@redhat.com>
Date: Mon, 18 Jan 2010 13:01:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>	 <1263467289.4244.288.camel@laptop>	 <1263498366.4875.25.camel@localhost.localdomain>	 <1263546228.4244.343.camel@laptop>  <20100115093831.GC26396@in.ibm.com>	 <1263549014.4244.374.camel@laptop>  <4B53213C.9050303@redhat.com>	 <1263739939.557.20938.camel@twins>  <4B5325CF.5000001@redhat.com>	 <1263740593.557.20967.camel@twins>  <4B53661A.9090907@redhat.com> <1263800752.4283.19.camel@laptop>
In-Reply-To: <1263800752.4283.19.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 09:45 AM, Peter Zijlstra wrote:
>
>> This is debugging.  We're playing with registers, we're playing with the
>> cpu, we're playing with memory contents.  Why not the address space as well?
>>      
> Because you want thins go to be as transparent as possible in order to
> avoid heisenbugs. Sure we cannot avoid everything, but we should avoid
> everything we possibly can.
>    

If we reserve some address space, you don't add any heisenbugs (at 
least, not any additional ones over emulation).  Even if we don't, 
address space layout randomization means we're not keeping the address 
space layout constant between runs anyway.

> Also, aside of the VDSO, we simply do not force map things into address
> spaces (and like said before, I think the VDSO stinks for doing that)
> and I think we don't want to create (more) precedents in this case.
>    

You've made it clear that you don't like it, but not why.

The kernel already manages the user's address space (except for 
MAP_FIXED which is unreliable unless you've already reserved the address 
space).  I don't see why adding a vma for debugging is so horrible.

-- 
error compiling committee.c: too many arguments to function

