Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYLDWFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYLDWFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbYLDWFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:05:35 -0500
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:45738 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755987AbYLDWFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:05:34 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Thu, 4 Dec 2008 22:05:11 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Avi Kivity <avi@redhat.com>
Cc: Steven Rostedt <srostedt@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
Message-ID: <20081204220511.GA3510@hades.domain.com>
References: <4932F59D.2060002@redhat.com> <20081130203833.GA14903@hades> <4932FB47.6090300@redhat.com> <20081130210406.GA17952@hades> <493528D8.8010904@redhat.com> <20081202190914.GA12115@hades> <20081202194610.GA4864@hades> <1228249509.4886.11.camel@localhost.localdomain> <49359CDF.5060300@redhat.com> <4937F8F1.3070402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4937F8F1.3070402@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 05:36:17PM +0200, Avi Kivity wrote:
> Avi Kivity wrote:
>> Steven Rostedt wrote:
>>> The following must be available without recursion for the function
>>> tracer to work:
>>>
>>>   local_irq_save/restore
>>>   smp_processor_id
>>>   preempt_enable/disable_notrace
>>>   atomic_inc/dec
>>>   
>>
>> In arch/x86/kvm/svm.c, function svm_vcpu_run(), everything between the  
>> vmrun instruction and the call to load_host_msrs() is executed without  
>> a live pda, so no smp_processor_id().  Could easily be fixed by  
>> rearranging things.
>>
>>
>
> Luis, please try the attached patch.

Sorry for taking so long testing the patch.  However, I got exactly the same
result as before, i.e., a crash.

Regards,
-- 
Luis Henriques
