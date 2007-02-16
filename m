Return-Path: <linux-kernel-owner+w=401wt.eu-S1946074AbXBPWKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946074AbXBPWKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946146AbXBPWKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:10:50 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:54349 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946074AbXBPWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:10:49 -0500
Message-ID: <45D62BE8.6000702@vmware.com>
Date: Fri, 16 Feb 2007 14:10:48 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for paravirt_ops
 interface
References: <20070216022449.739760547@goop.org> <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com> <45D61C74.2000601@vmware.com> <Pine.LNX.4.64.0702161312460.28871@schroedinger.engr.sgi.com> <45D626BB.20007@vmware.com> <Pine.LNX.4.64.0702161356380.29218@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702161356380.29218@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 16 Feb 2007, Zachary Amsden wrote:
>
>   
>> Yes, but that is just because the Xen hooks happens to be near the last part
>> of the merge.  VMI required some special hooks, as do both Xen and lhype (I
>> think ... Rusty can correct me if lhype's puppy's have precluded the addition
>> of new hooks).  Xen page table handling is very different, mostly it is trap
>> and emulate so writable page tables can work, which means they don't always
>> issue hypercalls for PTE updates, although they do have that option, should
>> the hypervisor MMU model change, or performance concerns prompt a different
>> model (or perhaps, migration?)
>>     
>
> Well looks like there are still some major design issues to be ironed out. 
> What is proposed here is to make paravirt_ops a fake generic 
> API and then tunnel through it to vendor specific kernel mods.
>   

No, there are two radically different approaches represented in one 
API.  Shadow page tables and direct page tables require different 
abstractions to make them work.  The API is not fake.  It accommodates 
both approaches, and the Xen changes here are pretty much required to 
make direct page tables work.  The shadow side of the equation is not 
vendor specific, in fact, it is used by lhype to make PTE update 
hypercalls.  But only one vendor chose direct page tables, so it appears 
vendor specific, when in fact it is just specific to that design choice.

Adding XenBus hooks to paravirt-ops, for instance, would be vendor 
specific and useless to anyone else.  But that is not the approach which 
has been taken here.

Zach
