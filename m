Return-Path: <linux-kernel-owner+w=401wt.eu-S932510AbXBPR1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbXBPR1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXBPR1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:27:42 -0500
Received: from gw.goop.org ([64.81.55.164]:43119 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510AbXBPR1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:27:41 -0500
Message-ID: <45D5E98B.4070904@goop.org>
Date: Fri, 16 Feb 2007 09:27:39 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Keir Fraser <keir@xensource.com>
CC: Andi Kleen <ak@muc.de>, Zachary Amsden <zach@vmware.com>,
       xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
       linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and free
 vmalloc areas
References: <C1FB967F.998B%keir@xensource.com>
In-Reply-To: <C1FB967F.998B%keir@xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> On 16/2/07 17:10, "Keir Fraser" <keir@xensource.com> wrote:
>
>   
>> On 16/2/07 16:46, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:
>>
>>     
>>> Yes, that would work.  Unfortunately that's i386 arch-specific, whereas
>>> the rest of this code is generic.  I guess I could just move it all to
>>> arch/i386/mm.
>>>       
>> This whole thing isn't an issue on ia64 (they no-op lock_vm_area) and
>> powerpc doesn't use any of the Xen driver code at this time.
>> vmalloc_sync_all is supported by both i386 and x86_64, so we can make the
>> call conditional on CONFIG_X86 so that ia64 will continue to build. This is
>> what I've done in xen-unstable.
>>     
>
>
> In fact that file is only built for i386 and x86_64, so there really is no
> problem with using vmalloc_sync_all() directly and without ifdef.
>   

I had moved it to mm/vmalloc.c in response to previous review comments
(namely, its not Xen specific, so it shouldn't live in the Xen part of
the tree).

    J
