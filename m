Return-Path: <linux-kernel-owner+w=401wt.eu-S1030668AbXCNGyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030668AbXCNGyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 02:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030670AbXCNGyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 02:54:54 -0400
Received: from ozlabs.org ([203.10.76.45]:37699 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030668AbXCNGyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 02:54:53 -0400
Subject: Re: [PATCH 0/8] x86 boot, pda and gdt cleanups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <45F77C9F.6040203@goop.org>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <45F70E25.7050704@goop.org>
	 <1173839149.5443.26.camel@localhost.localdomain>
	 <45F77C9F.6040203@goop.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 17:54:26 +1100
Message-Id: <1173855267.19022.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 21:39 -0700, Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > This is called "pissing in the corners".  Don't do it: we don't need to
> > touch that code and I actually prefer the original anyway (explicit is
> > *good*).  
> >
> > The habit of extracting cpu number once then using it is an optimization
> > which we should be aiming to get rid of (it simply hurts archs with
> > efficient per-cpu implementations).
> 
> No, that was for a reason.  I was worried about smp_processor_id() not
> returning valid values between init_gdt and cpu_set_gdt.  It's not
> actually a problem, but relying on smp_processor_id() while we're moving
> the foundations its based on seems fragile.

smp_processor_id() always works, so it's fundamental, not fragile.

However, we *should* remove the arg from cpu_set_gdt, since we have such
faith in smp_processor_id() 8)

Cheers,
Rusty.



