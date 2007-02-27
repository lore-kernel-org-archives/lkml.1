Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbXB0SzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbXB0SzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 13:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbXB0SzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 13:55:22 -0500
Received: from gw.goop.org ([64.81.55.164]:58629 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXB0SzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 13:55:20 -0500
Message-ID: <45E47E95.2060803@goop.org>
Date: Tue, 27 Feb 2007 10:55:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 06/26] Xen-paravirt_ops: paravirt_ops: allocate a fixmap
 slot
References: <20070227081337.434798469@goop.org> <20070227081631.122933982@goop.org> <20070227101143.GC10827@elte.hu>
In-Reply-To: <20070227101143.GC10827@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Allocate a fixmap slot for use by a paravirt_ops implementation.  Xen 
>> uses this to map the hypervisor's shared info page, which doesn't have 
>> a pseudo-physical page number, and therefore can't be mapped 
>> ordinarily.
>>     
>
> why not vmalloc it on the guest side? fixmaps are bad for this purpose 
> for a general paravirt implementation, it limits the size of the shared 
> info page, etc.

Yes.  vmalloc would have the annoying side-effect of actually allocating
some pages which would be shadowed by the remapping, but I guess
get_vm_area would do the job.  I'll give it a go.

    J
