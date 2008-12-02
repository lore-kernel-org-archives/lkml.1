Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYLBUtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYLBUtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYLBUs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:48:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33829 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYLBUs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:48:57 -0500
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
From: Steven Rostedt <srostedt@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Luis Henriques <henrix@sapo.pt>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <49359CDF.5060300@redhat.com>
References: <20081130193401.GA7690@hades> <4932F59D.2060002@redhat.com>
	 <20081130203833.GA14903@hades> <4932FB47.6090300@redhat.com>
	 <20081130210406.GA17952@hades> <493528D8.8010904@redhat.com>
	 <20081202190914.GA12115@hades>  <20081202194610.GA4864@hades>
	 <1228249509.4886.11.camel@localhost.localdomain>
	 <49359CDF.5060300@redhat.com>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 02 Dec 2008 15:48:41 -0500
Message-Id: <1228250921.4886.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-12-02 at 22:38 +0200, Avi Kivity wrote:
> Steven Rostedt wrote:
> > The following must be available without recursion for the function
> > tracer to work:
> >
> >   local_irq_save/restore
> >   smp_processor_id
> >   preempt_enable/disable_notrace
> >   atomic_inc/dec
> >   
> 
> In arch/x86/kvm/svm.c, function svm_vcpu_run(), everything between the 
> vmrun instruction and the call to load_host_msrs() is executed without a 
> live pda, so no smp_processor_id().  Could easily be fixed by 
> rearranging things.

That would be best, but if you have trouble, you could surround the
trouble area with a: tracing_stop(); tracing_start(); That will prevent
tracing within those locations. The function tracer will still be
called, but it will exit the function without doing anything else.

Note: that stops tracing on all CPUS, not just the CPU that called it.

-- Steve


