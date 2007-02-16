Return-Path: <linux-kernel-owner+w=401wt.eu-S1946286AbXBPXdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946286AbXBPXdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946291AbXBPXdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:33:11 -0500
Received: from gw.goop.org ([64.81.55.164]:51484 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946286AbXBPXdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:33:10 -0500
Message-ID: <45D63F35.3000101@goop.org>
Date: Fri, 16 Feb 2007 15:33:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 07/21] Xen-paravirt: remove ctor for pgd cache
References: <20070216022449.739760547@goop.org> <20070216022531.047039320@goop.org> <Pine.LNX.4.64.0702161229360.26650@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702161229360.26650@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 15 Feb 2007, Jeremy Fitzhardinge wrote:
>
>   
>> Remove the ctor for the pgd cache.  There's no point in having the
>> cache machinery do this via an indirect call when all pgd are freed in
>> the one place anyway.
>>     
>
> Great. We finally get rid of this evil ..... 
>
> On second throughts:
>
> Are you sure that you understand what you are modifying? The ctor is not 
> called when you allocate an object but when the slab allocates it. Freeing 
> an object does not make the slab free it. It will hold it for the next
> kmalloc. So you may just have reduced performance somewhat by addiung 
> additional ctor processing and possibly disturbed the preservation of 
> cache hot pgds.
It's true I wrote this patch as a result of accidentally reading slob.c
rather than slab.c, which was mostly as a result of hopeful thinking (I
knew that there has been discussion about removing all the slab cache
stuff, and I assumed that it had already happened).  As a result I'm
withdrawing this patch for now, but with any luck it will be useful at
some point.

    J
