Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZEUIrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZEUIrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 04:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZEUIrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 04:47:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44312 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbZEUIri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 04:47:38 -0400
Message-ID: <4A15151A.6000708@redhat.com>
Date: Thu, 21 May 2009 11:47:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@amd.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, peterz@infradead.org,
       Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 4] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com> <200905081203.55484.mark.langsdorf@amd.com> <200905191356.37071.mark.langsdorf@amd.com> <200905201725.18046.mark.langsdorf@amd.com>
In-Reply-To: <200905201725.18046.mark.langsdorf@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Langsdorf wrote:
> This feature creates a new field in the VMCB called Pause
> Filter Count.  If Pause Filter Count is greater than 0 and
> intercepting PAUSEs is enabled, the processor will increment
> an internal counter when a PAUSE instruction occurs instead
> of intercepting.  When the internal counter reaches the
> Pause Filter Count value, a PAUSE intercept will occur.
>
> This feature can be used to detect contended spinlocks,
> especially when the lock holding VCPU is not scheduled.
> Rescheduling another VCPU prevents the VCPU seeking the
> lock from wasting its quantum by spinning idly.  Perform
> the reschedule by increasing the the credited time on
> the VCPU.
>
> Experimental results show that most spinlocks are held
> for less than 1000 PAUSE cycles or more than a few
> thousand.  Default the Pause Filter Counter to 3000 to
> detect the contended spinlocks.
>
> Processor support for this feature is indicated by a CPUID
> bit.
>
> On a 24 core system running 4 guests each with 16 VCPUs,
> this patch improved overall performance of each guest's
> 32 job kernbench by approximately 1%.  Further performance
> improvement may be possible with a more sophisticated
> yield algorithm.
>   

Please split this into a scheduler patch and a kvm patch.


-- 
error compiling committee.c: too many arguments to function

