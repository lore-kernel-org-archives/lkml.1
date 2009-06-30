Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZF3QpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZF3QpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 12:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZF3Qo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 12:44:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54139 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZF3Qoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 12:44:55 -0400
To: Gleb Natapov <gleb@redhat.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi\@redhat.com" <avi@redhat.com>
References: <20090629132926.GB20289@redhat.com>
	<m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 30 Jun 2009 09:44:54 -0700
In-Reply-To: <20090630092623.GI20289@redhat.com> (Gleb Natapov's message of "Tue\, 30 Jun 2009 12\:26\:23 +0300")
Message-ID: <m1eit1acxl.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gleb@redhat.com, avi@redhat.com, kvm@vger.kernel.org, sheng@linux.intel.com, suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gleb Natapov <gleb@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> writes:

> On Tue, Jun 30, 2009 at 02:24:05AM -0700, Eric W. Biederman wrote:
>> Gleb Natapov <gleb@redhat.com> writes:
>> 
>> > KVM would like to provide x2APIC interface to a guest without emulating
>> > interrupt remapping device. The reason KVM prefers guest to use x2APIC
>> > is that x2APIC interface is better virtualizable and provides better
>> > performance than mmio xAPIC interface:
>> >
>> > - msr exits are faster than mmio (no page table walk, emulation)
>> > - no need to read back ICR to look at the busy bit
>> > - one 64 bit ICR write instead of two 32 bit writes
>> > - shared code with the Hyper-V paravirt interface
>> >     
>> > Included patch changes x2APIC enabling logic to enable it even if IR
>> > initialization failed, but kernel runs under KVM and no apic id is
>> > greater than 255 (if there is one spec requires BIOS to move to x2apic
>> > mode before starting an OS).
>> 
>> 
>> How common is hotplug hardware in kvm?  In particular hotplug cpus?
>> 
> It works for Linux guests.

>
>> To support that seriously you need interrupt remapping.
>> 
> Can you explain why?

Because ioapics don't fully function according to spec,
and the interrupt code on the hotplug path is a horrible
terrible broken hack for ioapics.

It is better than nothing but it certainly is not something
I would expect to work all of the time.

Interrupt remapping is the one case where we have hardware
that works according to spec and that works reasonably well.

Eric
