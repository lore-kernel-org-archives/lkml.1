Return-Path: <linux-kernel-owner+w=401wt.eu-S932426AbXBPVuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbXBPVuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932599AbXBPVuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:50:35 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40738 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932426AbXBPVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:50:34 -0500
Message-ID: <45D626BB.20007@vmware.com>
Date: Fri, 16 Feb 2007 13:48:43 -0800
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
References: <20070216022449.739760547@goop.org> <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com> <45D61C74.2000601@vmware.com> <Pine.LNX.4.64.0702161312460.28871@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702161312460.28871@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 16 Feb 2007, Zachary Amsden wrote:
>
>   
>> For the most part, it doesn't disturb VMware or KVM.  Xen does need some
>> additional functionality in paravirt-ops because they took a different design
>> choice - direct page tables instead of shadow page tables.  This is where all
>> the requirements for the new Xen paravirt-ops hooks come from.
>>     
>
> It still seems to be implemented for Xen and not to support a variety of 
> page table methods in paravirt ops.
>   

Yes, but that is just because the Xen hooks happens to be near the last 
part of the merge.  VMI required some special hooks, as do both Xen and 
lhype (I think ... Rusty can correct me if lhype's puppy's have 
precluded the addition of new hooks).  Xen page table handling is very 
different, mostly it is trap and emulate so writable page tables can 
work, which means they don't always issue hypercalls for PTE updates, 
although they do have that option, should the hypervisor MMU model 
change, or performance concerns prompt a different model (or perhaps, 
migration?)

Zach
