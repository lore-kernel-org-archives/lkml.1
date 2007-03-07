Return-Path: <linux-kernel-owner+w=401wt.eu-S1030776AbXCGDGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030776AbXCGDGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 22:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161227AbXCGDGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 22:06:06 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52630 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030776AbXCGDGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 22:06:05 -0500
Message-ID: <45EE2C1A.4000000@vmware.com>
Date: Tue, 06 Mar 2007 19:06:02 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
CC: "Nakajima, Jun" <jun.nakajima@intel.com>,
       virtualization <virtualization@lists.osdl.org>,
       Roland McGrath <roland@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
References: <45ED82D9.6050204@codemonkey.ws>	 <8FFF7E42E93CC646B632AB40643802A80229779B@scsmsx412.amr.corp.intel.com>	 <20070306203712.GC21736@elte.hu> <1173228246.4644.85.camel@localhost.localdomain>
In-Reply-To: <1173228246.4644.85.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-03-06 at 21:37 +0100, Ingo Molnar wrote:
>   
>> maybe i shouldnt call it 'VMI' but 'the paravirt ABI'. I dont mind if 
>> it's the Xen ABI or the VMWare ABI or a mesh of the two - everyone can 
>> map their own internals to that /one/ ABI.
>>     
>
> I think it's an excellent aim, but it's *HARD*.  I rejected this
> approach earlier because I'm just not smart enough.  (Yet?)
>   

With VMI, I think we came within 90% of getting a cross vendor 
paravirt-ABI that satisfied everyone's needs.  Nobody is smart enough to 
figure out the last 10% - it needs cooperation, trial, error, and 
experience dealing with each other's hypervisors.

> The Linux side is fairly stable.  The hardware side is changing, and the
> hypervisor side is changing.  This means the ABI will churn fairly fast.
> The hypervisors are very different, which means the ABI will be very
> wide.
>
> We could start with VMI and try to support Xen, KVM and lguest.  It
> would at least give us a better idea of the scope of the problem.  But
> IMHO it's a *huge* job.
>   

Surely, given time, the technical issues can be worked out.  In the 
meantime, the hardware has evolved, and many of the points that are now 
important have changed - and new issues have come into play that we 
can't anticipate yet.  At some point, we will hopefully converge, but we 
might not, and it is a huge job.  UDI had similarly lofty goals.  It was 
started in 1998.  Where is it today?

But this isn't the problem.  The problem is that nobody wants a single 
ABI.  Just like no hardware vendors want a fixed ABI for their 
hardware.  They need to innovate independently, and time to market and 
features are more important than being binary compatible with a bunch of 
competing vendors.  They want to differentiate, and break away from an 
ABI, and as history repeats, again and again, this happens eventually 
with every ABI.

So once the ivory tower is built, and you let all the kids in to play, 
they are going to have a party and you are going to start noticing chips 
and eventually cracks, and eventually the tower will go into disrepair 
and fall because somebody else has built a new and better one further 
down the road.  Why go through that exercise if nobody sees any tangible 
benefit from it today?

Paravirt-ops avoids this because it is an API, and because it is 
flexible, and because it can change with the kernel, and because it 
doesn't lock you into a legacy way of doing things, it allows you to 
fork and adapt and push legacy and future compatibility issues into the 
vendor backend modules, like VMI, where they should belong.

Zach
