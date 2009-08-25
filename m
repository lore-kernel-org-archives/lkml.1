Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZHYKYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZHYKYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZHYKYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:24:34 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:41798 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZHYKYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:24:33 -0400
Date: Tue, 25 Aug 2009 15:54:22 +0530
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kamezawa.hiroyu@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 6/8] powerpc: add CONFIG_KEXEC_AUTO_RESERVE
Message-ID: <20090825102422.GA14591@in.ibm.com>
Reply-To: mohan@in.ibm.com
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain> <20090821065739.4855.19179.sendpatchset@localhost.localdomain> <1251121443.10645.56.camel@concordia> <20090824144542.GB11956@in.ibm.com> <4A938698.40302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A938698.40302@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 02:37:12PM +0800, Amerigo Wang wrote:
> M. Mohan Kumar wrote:
>> On Mon, Aug 24, 2009 at 11:44:03PM +1000, Michael Ellerman wrote:
>>   
>>> On Fri, 2009-08-21 at 02:55 -0400, Amerigo Wang wrote:
>>>     
     
>>> That aside, I don't see how this will be useful in practice, if it only
>>> works for memory sizes over 4G? Or are we saying that people with less
>>> than 4G don't need crash kernels? If we're not saying that, those users,
>>> or those users' distros, still need to do some logic to work out if they
>>> have < 4GB of memory and if so pick a crash kernel size. So why can't
>>> they pick the size in the > 4GB case also?
>>>     
>>
>> True, I wanted to test the patch and when tested on a ppc64 machine which
>> has RAM less than 4GB, I have to modify arch_default_crash_size routine to
>> return 256MB (I didn't have a PPC64 machine with more than 4GB RAM handy).
>> So its better to consider machines with less than 4GB RAM also.
>>   
>
> OK, how about 2G on ppc? Is it safe to reserve 256M when I have 2G?

I would prefer 2G-4G 128MB.

>
>> PPC64 crashkernel base is always 32MB. So at least ppc64 code should have
>> its own arch_default_crash_base to return 32MB to avoid the kernel warning
>> message "Crash kernel location must be 0x2000000"
>>   
> Hmm, good point, how about KDUMP_KERNELBASE? It looks fine for both ppc  
> and ppc64.

Yes, you can use KDUMP_KERNELBASE for arch_default_crash_base

Regards,
M. Mohan Kumar
