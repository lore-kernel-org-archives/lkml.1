Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbXBPXbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbXBPXbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946285AbXBPXbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:31:06 -0500
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:57158 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbXBPXbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:31:05 -0500
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Fri, 16 Feb 2007 23:29:57 +0000
Subject: Re: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and free
 vmalloc areas
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Keir Fraser <keir@xensource.com>, Ian Pratt <ian.pratt@xensource.com>,
       <xen-devel@lists.xensource.com>, Chris Wright <chrisw@sous-sol.org>,
       <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@novell.com>,
       Andi Kleen <ak@muc.de>
Message-ID: <C1FBEEF5.2256%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and
 free vmalloc areas
Thread-Index: AcdSIl5unR3Zsr4VEduoPQAWy6hiGQ==
In-Reply-To: <45D60569.2050702@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/2/07 19:26, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> Keir Fraser wrote:
>> Hmmm... Actually looks like a bunch of architectures do lazy sync of the
>> vmalloc area, although neither ia64 nor powerpc does so. However, all
>> current users of the alloc_vm_area() function would be okay since none of
>> the other lazy-syncing architectures are supported by Xen.
>>   
> 
> Well, assuming that alloc_vm_area() has some non-Xen use, the right
> thing is for archs to export vmalloc_sync_all(), and just use that from
> common code.

It has no other users right now and get_vm_area_sync() would be a
better-named and more generically useful function than alloc_vm_area(). But
yes, to be done properly it does require vmalloc_sync_all() to be defined by
all architectures (even if that's BUG() and implement-properly-on-demand).

get_vm_area_sync(), partnered with existing remove_vm_area(), just seems
much smaller and neater than adding four new functions with a more complex
usage: alloc_vm_area, {lock,unlock}_vm_area, and free_vm_area. Maybe keeping
free_vm_area() too makes sense as its interface is more neatly symmetrical
to that of get_vm_area().

 -- Keir


