Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578Ab0AQTe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab0AQTe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 14:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552Ab0AQTe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 14:34:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab0AQTe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 14:34:27 -0500
Message-ID: <4B53661A.9090907@redhat.com>
Date: Sun, 17 Jan 2010 21:33:46 +0200
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
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>	 <1263467289.4244.288.camel@laptop>	 <1263498366.4875.25.camel@localhost.localdomain>	 <1263546228.4244.343.camel@laptop>  <20100115093831.GC26396@in.ibm.com>	 <1263549014.4244.374.camel@laptop>  <4B53213C.9050303@redhat.com>	 <1263739939.557.20938.camel@twins>  <4B5325CF.5000001@redhat.com> <1263740593.557.20967.camel@twins>
In-Reply-To: <1263740593.557.20967.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2010 05:03 PM, Peter Zijlstra wrote:
>
>> btw, an alternative is to require the caller to provide the address
>> space for this.  If the caller is in another process, we need to allow
>> it to play with the target's address space (i.e. mmap_process()).  I
>> don't think uprobes justifies this by itself, but mmap_process() can be
>> very useful for sandboxing with seccomp.
>>      
> mmap_process() sounds utterly gross, one process playing with another
> process's address space.. yuck!
>    

This is debugging.  We're playing with registers, we're playing with the 
cpu, we're playing with memory contents.  Why not the address space as well?

For seccomp, this really should be generalized.  Run a system call on 
behalf of another process, but don't let that process do anything to 
affect it.  I think Google is doing something clever with one thread in 
seccomp mode and another unconstrained, but that's very hacky - you have 
to stop the constrained thread so it can't interfere with the live one.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

