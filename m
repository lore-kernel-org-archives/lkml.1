Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZIVQwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZIVQwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbZIVQw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:52:29 -0400
Received: from claw.goop.org ([74.207.240.146]:55770 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141AbZIVQw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:52:27 -0400
Message-ID: <4AB900CC.7090409@goop.org>
Date: Tue, 22 Sep 2009 09:52:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com> <20090919224430.GB9567@kroah.com> <1253419185.3253.21.camel@ank32.eng.vmware.com> <20090920074247.GA5733@elte.hu> <20090920095239.456ad6f2@infradead.org> <4AB5EF25.9070502@redhat.com> <4AB64EFC.10707@goop.org> <20090922080913.GB1475@elte.hu>
In-Reply-To: <20090922080913.GB1475@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/09 01:09, Ingo Molnar wrote:
>>> kvm will be removing the pvmmu support soon; and Xen is talking about
>>> running paravirtualized guests in a vmx/svm container where they don't
>>> need most of the hooks.
>>>       
>> We have no plans to drop support for non-vmx/svm capable processors, 
>> let alone require ept/npt.
>>     
> But, just to map out our plans for the future, do you concur with the 
> statements and numbers offered here by the VMware and KVM folks that
> on sufficiently recent hardware, hardware-assisted virtualization 
> outperforms paravirt_ops in many (most?) workloads?
>   

Well, what Avi is referring to here is some discussions about a hybrid
paravirtualized mode, in which Xen runs a normal Xen PV guest within a
hardware container in order to get some immediate optimisations, and
allow further optimisations like using hardware assisted paging extensions.

For KVM and VMI, which always use a shadow pagetable scheme, hardware
paging is now unambigiously better than shadow pagetables, but for Xen
PV guests the picture is mixed since they don't use shadow pagetables. 
The NPT/EPT extensions make updating the pagetable more efficent, but
actual access is more expensive because of the higher load on the TLB
and the increased expense of a TLB miss, so the actual performance
effects are very workload dependent.

> I.e. paravirt_ops becomes a legacy hardware thing, not a core component 
> of the design of arch/x86/.
>
> (with a long obsoletion period, of course.)
>   

I expect we'll eventually get to the point that the performance delta
and the installed userbase will no longer justify the effort in
maintaining the full set of pvops hooks.  But I don't have a good
feeling for when that might be.

    J
