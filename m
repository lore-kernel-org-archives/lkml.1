Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbZCEOh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbZCEOh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZCEOhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:37:11 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:26600 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbZCEOhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:37:10 -0500
Message-ID: <49AFE390.5070001@codemonkey.ws>
Date: Thu, 05 Mar 2009 08:37:04 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: George Dunlap <George.Dunlap@eu.citrix.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	 <200902282309.07576.nickpiggin@yahoo.com.au>	 <49AB19E1.4050604@goop.org>	 <200903021737.24903.nickpiggin@yahoo.com.au>	 <49AB9336.7010103@goop.org> <49AEBB8C.2000405@codemonkey.ws> <de76405a0903050259j5a0f9649v28e8f8fd29003d5f@mail.gmail.com>
In-Reply-To: <de76405a0903050259j5a0f9649v28e8f8fd29003d5f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Dunlap wrote:
> On Wed, Mar 4, 2009 at 5:34 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
>   
>> Can you point to benchmarks?  I have a hard time believing this.
>>
>> How can shadow paging beat nested paging assuming the presence of large
>> pages?
>>     
>
> If these benchmarks would help this discussion, we can certainly run
> some.  As of last Fall, even with superpage support, certain workloads
> perform significantly less well with HAP (hardware-assisted paging)
> than with shadow pagetables.  Examples are specjbb, which does almost
> no pagetable updates, but totally thrashes the TLB.

I suspected specjbb was the benchmark.   specjbb is really an anomaly as 
it's really the only benchmark where even a naive shadow paging 
implementation performs very close to native.

specjbb also turns into a pathological case with HAP.  In my 
measurements, HAP with 4k pages was close to 70% of native for specjbb.  
Once you enable large pages though, you get pretty close to native.  
IIRC, around 95%.  I suspect that over time as the caching algorithms 
improve, this will approach 100% of native.

Then again, there are workloads like kernbench that are pathological for 
shadow paging in a much more dramatic way.  At least on shadow2, I was 
seeing around 60% of native with kernbench.  With direct paging, it goes 
to about 85% of native.  With NPT and large pages, it's almost 100% of 
native.

>   SysMark also
> performed much better with shadow pagetables than HAP.  And of course,
> 64-bit is worse than 32-bit.  (It's actually a bit annoying from a
> default-policy perspective, since about half of our workloads perform
> better with HAP (up to 30% better) and half of them perform worse (up
> to 30% worse)).
>
> Our comparison would, of course, be comparing Xen+HAP to Xen+Shadow,
> which isn't necessarily comparable to KVM+HAP.
>
> Having HAP work well would be great for us as well as KVM.  But
> there's still the argument about hardware support: Xen can run
> paravirtualized VMs on hardware with no HVM support, and can run fully
> virtualized domains very well on hardware that has HVM support but not
> HAP support.
>   

Xen is definitely not going away and as such, supporting it in Linux 
seems like a good idea to me.  I'm just refuting claims that the Xen 
architecture has intrinsic advantages wrt MMU virtualization.  It's 
simply not the case :-)

Regards,

Anthony Liguori

>  -George Dunlap
>   

