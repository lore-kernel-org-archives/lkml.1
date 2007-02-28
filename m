Return-Path: <linux-kernel-owner+w=401wt.eu-S1751146AbXB1AuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbXB1AuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 19:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXB1AuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 19:50:11 -0500
Received: from gw.goop.org ([64.81.55.164]:46931 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbXB1AuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 19:50:10 -0500
Message-ID: <45E4D1B1.7030903@goop.org>
Date: Tue, 27 Feb 2007 16:49:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 06/26] Xen-paravirt_ops: paravirt_ops: allocate a fixmap
 slot
References: <20070227081337.434798469@goop.org> <20070227081631.122933982@goop.org> <20070227101143.GC10827@elte.hu> <45E47E95.2060803@goop.org>
In-Reply-To: <45E47E95.2060803@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
>   
>> why not vmalloc it on the guest side? fixmaps are bad for this purpose 
>> for a general paravirt implementation, it limits the size of the shared 
>> info page, etc.
>>     
>
> Yes.  vmalloc would have the annoying side-effect of actually allocating
> some pages which would be shadowed by the remapping, but I guess
> get_vm_area would do the job.  I'll give it a go.

Hm, this is a bit awkward.  We need to map the shared info page fairly
early - say, around paging_init - but we're still on the bootmem
allocator at that point, so get_vm_area isn't usable yet.  Using a
fixmap keeps things simple.  It seems to me that having a single fixmap
available is useful for this kind of simple/early mapping, and if
someone needs to map something larger, then they can put it off until
get_vm_area() is available...

    J
