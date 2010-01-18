Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647Ab0ARMht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0ARMht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028Ab0ARMht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:37:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab0ARMhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:37:48 -0500
Message-ID: <4B5455FF.7010409@redhat.com>
Date: Mon, 18 Jan 2010 14:37:19 +0200
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
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>	 <1263467289.4244.288.camel@laptop>	 <1263498366.4875.25.camel@localhost.localdomain>	 <1263546228.4244.343.camel@laptop>  <20100115093831.GC26396@in.ibm.com>	 <1263549014.4244.374.camel@laptop>  <4B53213C.9050303@redhat.com>	 <1263739939.557.20938.camel@twins>  <4B5325CF.5000001@redhat.com>	 <1263740593.557.20967.camel@twins>  <4B53661A.9090907@redhat.com>	 <1263800752.4283.19.camel@laptop>  <4B543F93.3060509@redhat.com>	 <1263815072.4283.305.camel@laptop>  <4B544D7C.2060708@redhat.com>	 <1263816396.4283.361.camel@laptop>  <4B544F8E.1080603@redhat.com> <1263816857.4283.381.camel@laptop>
In-Reply-To: <1263816857.4283.381.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 02:14 PM, Peter Zijlstra wrote:
>
>> Well, the alternatives are very unappealing.  Emulation and
>> single-stepping are going to be very slow compared to a couple of jumps.
>>      
> With CPL2 or RPL on user segments the protection issue seems to be
> manageable for running the instructions from kernel space.
>    

CPL2 gives unrestricted access to the kernel address space; and RPL does 
not affect page level protection.  Segment limits don't work on x86-64.  
But perhaps I missed something - these things are tricky.

It should be possible to translate the instruction into an address space 
check, followed by the action, but that's still slower due to privilege 
level switches.

-- 
error compiling committee.c: too many arguments to function

