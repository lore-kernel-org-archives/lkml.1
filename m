Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZLUPnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZLUPnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZLUPnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:43:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889AbZLUPnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:43:39 -0500
Message-ID: <4B2F978D.7010602@redhat.com>
Date: Mon, 21 Dec 2009 17:43:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com>
In-Reply-To: <4B2F9582.5000002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 05:34 PM, Gregory Haskins wrote:
>
>> I think it would be fair to point out that these patches have been objected to
>> by the KVM folks quite extensively,
>>      
> Actually, these patches have nothing to do with the KVM folks.  You are
> perhaps confusing this with the hypervisor-side discussion, of which
> there is indeed much disagreement.
>    

This is true, though these drivers are fairly pointless for 
virtualization without the host side support.

I did have a few issues with the guest drivers:
- the duplication of effort wrt virtio.  These drivers don't cover 
exactly the same problem space, but nearly so.
- no effort at scalability - all interrupts are taken on one cpu
- the patches introduce a new virtual interrupt controller for dubious 
(IMO) benefits

>  From my research, the reason why virt in general, and KVM in particular
> suffers on the IO performance front is as follows: IOs
> (traps+interrupts) are more expensive than bare-metal, and real hardware
> is naturally concurrent (your hbas and nics are effectively parallel
> execution engines, etc).
>
> Assuming my observations are correct, in order to squeeze maximum
> performance from a given guest, you need to do three things:  A)
> eliminate as many IOs as you possibly can, B) reduce the cost of the
> ones you can't avoid, and C) run your algorithms in parallel to emulate
> concurrent silicon.
>    

All these are addressed by vhost-net without introducing new drivers.

-- 
error compiling committee.c: too many arguments to function

