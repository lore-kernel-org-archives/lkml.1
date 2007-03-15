Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbXCOB5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbXCOB5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 21:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXCOB5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 21:57:05 -0400
Received: from gw.goop.org ([64.81.55.164]:35382 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbXCOB5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 21:57:03 -0400
Message-ID: <45F8A7ED.7090009@goop.org>
Date: Wed, 14 Mar 2007 18:57:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 0/8] x86 boot, pda and gdt cleanups
References: <1173184747.4644.23.camel@localhost.localdomain>	 <45F70E25.7050704@goop.org> <1173916541.19022.47.camel@localhost.localdomain>
In-Reply-To: <1173916541.19022.47.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Hmm, this invalidated my assumption that write_gdt_entry is always a
> write to this cpu's active gdt.  Better fix is not to call it twice
> anyway...
>   

No, I don't think that's true.  I implemented the write_*_entry
functions with the assumption they could be called either on setup or on
an in-use entry.  I think its good policy to use it all the time anyway,
since the pv_ops backend might want to fiddle with the values on the way
through.

I tried to avoid calling init_gdt twice, but it seemed cleaner to just
let it happen.

> Getting rid of the call in smp_prepare_boot_cpu currently works, but
> it's fragile:  __get_cpu_var(x) && per_cpu(x, smp_processor_id()) will
> differ, and changes made to __get_cpu_var(x) will vanish...
>   

Yes.  I think its definitely a good idea to call init_gdt asap after
doing the percpu setup.

> Fortunately, UP doesn't have to call init_gdt at all, so I think it's
> better to place it in smp_prepare_boot_cpu only and then clean up the UP
> code.  I'll try now...
>   
It doesn't?  The per-cpu gdt is the same as the boot gdt?


    J
