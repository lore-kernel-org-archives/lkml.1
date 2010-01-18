Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632Ab0ARMoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab0ARMoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422Ab0ARMoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:44:25 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45837 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab0ARMoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:44:24 -0500
Date: Mon, 18 Jan 2010 18:14:19 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100118124419.GC1628@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1263740593.557.20967.camel@twins>
 <4B53661A.9090907@redhat.com>
 <1263800752.4283.19.camel@laptop>
 <4B543F93.3060509@redhat.com>
 <1263815072.4283.305.camel@laptop>
 <4B544D7C.2060708@redhat.com>
 <1263816396.4283.361.camel@laptop>
 <4B544F8E.1080603@redhat.com>
 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
 <4B545146.3080001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4B545146.3080001@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2010-01-18 14:17:10]:

> On 01/18/2010 02:13 PM, Pekka Enberg wrote:
> >So how big chunks of the address space are we talking here for uprobes?
> 
> That's for the authors to answer, but at a guess, 32 bytes per probe
> (largest x86 instruction is 15 bytes), so 32 MB will give you a
> million probes.  That's a piece of cake for x86-64, probably harder
> to justify for i386.


On x86, each probe takes 16 bytes. 
In the current implementation of XOL, the first hit of a breakpoint,
requires us to allocate a page. If that page does get full with "active"
breakpoints, we expand / add a page. There is a bit map that keeps a
check to see if a previously used breakpoint is removed and hence that
slot can be reused.  By active breakpoints, I refer to those that are
inserted, and has been trapped atleast once but not yet removed.

Jim did try a few other allocation techniques but those that involved
slot stealing did end up having locking. People who did look at that
code did advise us to reduce the locking and keep the allocation simple
(atleast for the first cut).

--
Thanks and Regards
Srikar

> 
> -- 
> error compiling committee.c: too many arguments to function
> 
