Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbZA3Uut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbZA3Uut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZA3Uuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:50:37 -0500
Received: from smtp-out.google.com ([216.239.45.13]:57350 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbZA3Uug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:50:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:
	content-transfer-encoding:in-reply-to:x-operating-system:user-agent:
	x-gmailtapped-by:x-gmailtapped;
	b=KvYT7pUTJaCfft3PmYkkxLB8P+hZdU5E2qzMNVz52CEHa3A5+/tbm56eESYDu0PsH
	aFBZjiyA++NPjiHSZoMaQ==
Date: Fri, 30 Jan 2009 12:41:02 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] softlockup: remove hung_task_check_count
Message-ID: <20090130204102.GR22298@google.com>
References: <1232991701.4863.222.camel@laptop> <20090127003055.GA21269@google.com> <20090127132626.GH23121@elte.hu> <20090127184851.GD22298@google.com> <1233131100.10992.43.camel@laptop> <20090129014245.GM22298@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090129014245.GM22298@google.com>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.25.146.35
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines (msb@google.com) wrote:
> Peter Zijlstra (peterz@infradead.org) wrote:
> > 
> > Why break out at all? Are you that worried about khungtaskd introducing
> > latencies?
> 
> Yes, I was worried about disabling preemption for an unbounded amount of
> time.
> 
> > Is using preemptible RCU an option for you?
> > 
> 
> I had not even considered that. To be honest, I had not even heard of it
> till now. So I spent another morning at LWN grokking preemptible RCU;)
> 
> I think it can work. I'm a little worried about the OOM risk. It could take
> a really long time to iterate over the task list. A lot of pending kfree()s
> could build up in that time.
> 

I misunderstood preemptible RCU. I assumed it was a new API but its not. So
I don't think preemptible RCU is an option since it would force a dependency
on CONFIG_PREEMPT_RCU.

I'm going to break up this patch in two. One patch for converting to rcu.
A second patch which will support checking all tasks. To support checking
all tasks I reverted back to a design similar to Frédéric original proposal.

I'll send the patches out right after this email.

[PATCH 1/2] softlockup: convert read_lock in hung_task to rcu_read_lock
[PATCH 2/2] softlockup: check all tasks in hung_task

Regards,
Mandeep
