Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYLBUjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYLBUjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYLBUi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:38:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47710 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYLBUi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:38:57 -0500
Message-ID: <49359CDF.5060300@redhat.com>
Date: Tue, 02 Dec 2008 22:38:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Luis Henriques <henrix@sapo.pt>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
References: <20081130193401.GA7690@hades> <4932F59D.2060002@redhat.com>	 <20081130203833.GA14903@hades> <4932FB47.6090300@redhat.com>	 <20081130210406.GA17952@hades> <493528D8.8010904@redhat.com>	 <20081202190914.GA12115@hades>  <20081202194610.GA4864@hades> <1228249509.4886.11.camel@localhost.localdomain>
In-Reply-To: <1228249509.4886.11.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> The following must be available without recursion for the function
> tracer to work:
>
>   local_irq_save/restore
>   smp_processor_id
>   preempt_enable/disable_notrace
>   atomic_inc/dec
>   

In arch/x86/kvm/svm.c, function svm_vcpu_run(), everything between the 
vmrun instruction and the call to load_host_msrs() is executed without a 
live pda, so no smp_processor_id().  Could easily be fixed by 
rearranging things.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

