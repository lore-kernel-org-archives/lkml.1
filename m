Return-Path: <linux-kernel-owner+w=401wt.eu-S1946061AbXBPTHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946061AbXBPTHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946221AbXBPTHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:07:06 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:44727 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946061AbXBPTHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:07:03 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Feb 2007 19:06:58 +0000
Subject: Re: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and free
 vmalloc areas
From: Keir Fraser <keir@xensource.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Keir Fraser <keir@xensource.com>
CC: Zachary Amsden <zach@vmware.com>, <xen-devel@lists.xensource.com>,
       Ian Pratt <ian.pratt@xensource.com>, <virtualization@lists.osdl.org>,
       <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@novell.com>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Message-ID: <C1FBB152.99B0%keir@xensource.com>
Thread-Topic: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and
 free vmalloc areas
Thread-Index: AcdR/aFp4CN9q73wEduRUwAX8io7RQ==
In-Reply-To: <45D5E98B.4070904@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/2/07 17:27, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

>  In fact that file is only built for i386 and x86_64, so there really is no
>> problem with using vmalloc_sync_all() directly and without ifdef.
>>   
> 
> I had moved it to mm/vmalloc.c in response to previous review comments
> (namely, its not Xen specific, so it shouldn't live in the Xen part of
> the tree).

Then the call will have to be CONFIG_X86. I hadn't realised powerpc were
also using lock_vm_area. However I suspect that the x86 issue that those
functions were written doesn't even exist on powerpc, or any other non-x86
architecture.

I guess we should change the name of alloc_vm_area, by the way. Perhaps
alloc_vm_area_sync() or similar, to give some hint of what it's doing and
how it differs from other vmalloc-area functions?

 -- Keir

