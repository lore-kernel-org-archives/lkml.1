Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZJJJZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZJJJZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 05:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbZJJJZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 05:25:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbZJJJZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 05:25:07 -0400
Subject: Re: [PATCH RFC] sched: add notifier for process migration
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4AD04E50.7060001@redhat.com>
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop>
	 <4ACFBC98.4070701@goop.org> <1255158863.7866.25.camel@twins>
	 <4AD04E50.7060001@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 10 Oct 2009 11:24:22 +0200
Message-Id: <1255166662.7866.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 11:05 +0200, Avi Kivity wrote:
> On 10/10/2009 09:14 AM, Peter Zijlstra wrote:
> > Why not do something like:
> >
> >      struct {
> > 	u64 tsc;
> > 	u32 aux;
> >      } tscp = rdtscp();
> >
> >      local_time_info = timeinfo[tscp_cpu(tscp)];
> >
> >      /* yay, consistent tsc and timeinfo !! */
> >    
> 
> First, not all processors support rdtscp.

Is that a real issue? If its not supported by the early hardware virt
chips, tough luck, they sucked anyway :-)

>   Second, timeinfo might change 
> at any time due to cpu frequency changes or the entire cpu being 
> migrated, so we need to loop in any case.

Sure.
