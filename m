Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197Ab0AVSht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0AVSht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 13:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171Ab0AVSht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 13:37:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159Ab0AVShr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 13:37:47 -0500
Message-ID: <4B59F032.2060801@redhat.com>
Date: Fri, 22 Jan 2010 13:36:34 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 0/7] UBP, XOL and Uprobes [ Summary of Comments
 and actions to be taken ]
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>	 <20100122070232.GA2975@linux.vnet.ibm.com> <1264183574.4283.1558.camel@laptop>
In-Reply-To: <1264183574.4283.1558.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2010-01-22 at 12:32 +0530, Srikar Dronamraju wrote:
> 
>> 2. XOL vma vs Emulation vs Single Stepping Inline vs using Protection
>> Rings.
>> 	XOL VMA is an additional process address vma.  This is
>> 	opposition to add an additional vma without user actually
>> 	requesting for the same.
>>
>> 	XOL vma and single stepping inline are the two architecture
>> 	independent implementations. While other implementations are
>> 	more architecture specific. Single stepping inline wouldnt go
>> 	well with multithreaded process.
>>
>> 	Even though XOL vma has its own issues, we will go with it since
>> 	other implementations seem to have more complications.
>>
>> 	we would look forward to implementing boosters later. 
>> 	Later on, if we come across another techniques with lesser
>> 	side-effects than the XOL vma, we would switch to using them.
> 
> How about modifying glibc to reserve like 64 bytes on the TLS structure
> it has and storing the ins and possible boost jmp there? Since each
> thread can only have a single trap at any one time that should be
> enough.

Hmm, it is a good idea. Well, we'll have a copy of original insn
in kernel, but it could be simpler than managing XOL vma. :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

