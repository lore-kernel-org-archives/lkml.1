Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZGDJfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZGDJfn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 05:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZGDJfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 05:35:33 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57665 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZGDJfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 05:35:32 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Gleb Natapov <gleb@redhat.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi\@redhat.com" <avi@redhat.com>
References: <20090701133007.GC27539@redhat.com>
	<1246482017.27006.10670.camel@localhost.localdomain>
	<20090703082905.GF21833@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 04 Jul 2009 02:35:30 -0700
In-Reply-To: <20090703082905.GF21833@elte.hu> (Ingo Molnar's message of "Fri\, 3 Jul 2009 10\:29\:05 +0200")
Message-ID: <m1r5wwbxjx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: mingo@elte.hu, avi@redhat.com, kvm@vger.kernel.org, sheng@linux.intel.com, linux-kernel@vger.kernel.org, gleb@redhat.com, suresh.b.siddha@intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v5] enable x2APIC without interrupt remapping under KVM
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>
>> On Wed, 2009-07-01 at 06:30 -0700, Gleb Natapov wrote:
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
>> > 
>> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
>> 
>> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
> Now, since this affects core x86 APIC code non-trivially so should 
> submitted to and go via the x86 tree. (Can prepare a special branch 
> with just this change if KVM tree wants/needs to pull it before 
> v2.6.32.)

Please don't separate the x2apic code from the dmar code for this
reason.

Supporting hotplug cpus with ioapics is torture.

Eric
