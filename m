Return-Path: <linux-kernel-owner+w=401wt.eu-S933818AbXCNEkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818AbXCNEkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 00:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933821AbXCNEkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 00:40:00 -0400
Received: from gw.goop.org ([64.81.55.164]:39905 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933818AbXCNEkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 00:40:00 -0400
Message-ID: <45F77C9F.6040203@goop.org>
Date: Tue, 13 Mar 2007 21:39:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 0/8] x86 boot, pda and gdt cleanups
References: <1173184747.4644.23.camel@localhost.localdomain>	 <45F70E25.7050704@goop.org> <1173839149.5443.26.camel@localhost.localdomain>
In-Reply-To: <1173839149.5443.26.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> This is called "pissing in the corners".  Don't do it: we don't need to
> touch that code and I actually prefer the original anyway (explicit is
> *good*).  
>
> The habit of extracting cpu number once then using it is an optimization
> which we should be aiming to get rid of (it simply hurts archs with
> efficient per-cpu implementations).

No, that was for a reason.  I was worried about smp_processor_id() not
returning valid values between init_gdt and cpu_set_gdt.  It's not
actually a problem, but relying on smp_processor_id() while we're moving
the foundations its based on seems fragile.

    J
