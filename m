Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZIWHdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZIWHdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZIWHdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365AbZIWHdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:33:14 -0400
Message-ID: <4AB9CE66.1030504@redhat.com>
Date: Wed, 23 Sep 2009 09:29:42 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>	 <20090919224430.GB9567@kroah.com>	 <1253419185.3253.21.camel@ank32.eng.vmware.com>	 <20090920074247.GA5733@elte.hu> <1253647845.10565.20.camel@ank32.eng.vmware.com>
In-Reply-To: <1253647845.10565.20.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/09 21:30, Alok Kataria wrote:
> Hi Ingo,
>
> On Sun, 2009-09-20 at 00:42 -0700, Ingo Molnar wrote:
>
>>
>> The thing is, the overwhelming majority of vmware users dont benefit
>> from hardware features like nested page tables yet. So this needs to be
>> done _way_ more carefully, with a proper sunset period of a couple of
>> kernel cycles.
>
> I am fine with that too. Below is a patch which adds notes in
> feature-removal-schedule.txt, I have marked it for removal from 2.6.34.
> Please consider this patch for 2.6.32.

Hmm.  Given that you are talking about vmi not being supported any more 
in *future* products, there is a huge installed base with vmi support 
available, right?  I don't think we should zap the code that quickly.

>   config VMI
> -	bool "VMI Guest support"
> -	select PARAVIRT
> -	depends on X86_32
> +	bool "VMI Guest support [will be deprecated soon]"
> +	default n
> +	depends on X86_32&&  PARAVIRT
>   	---help---
>   	  VMI provides a paravirtualized interface to the VMware ESX server
>   	  (it could be used by other hypervisors in theory too, but is not
>   	  at the moment), by linking the kernel to a GPL-ed ROM module
>   	  provided by the hypervisor.
> +	  VMware has started a phased retirement of this feature from there
> +	  products. Please see feature-removal-schedule.txt for details.

How about adding version numbers here?  i.e. latest versions with vmi 
support are workstation x.y, ...

So people can easily figure whenever it makes sense to turn this on for 
their environment.

cheers
   Gerd

