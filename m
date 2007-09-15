Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbXIODFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbXIODFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 23:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXIODFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 23:05:47 -0400
Received: from ozlabs.org ([203.10.76.45]:39601 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbXIODFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 23:05:47 -0400
Subject: Re: [PATCH] Refactor hypercall infrastructure
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       Dor Laor <dor.laor@qumranet.com>, linux-kernel@vger.kernel.org
In-Reply-To: <46EAF4C6.8090903@goop.org>
References: <11897991353793-git-send-email-aliguori@us.ibm.com>
	 <46EAF4C6.8090903@goop.org>
Content-Type: text/plain
Date: Sat, 15 Sep 2007 12:35:02 +1000
Message-Id: <1189823702.7262.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 13:53 -0700, Jeremy Fitzhardinge wrote:
> Anthony Liguori wrote:
> > This patch refactors the current hypercall infrastructure to better support live
> > migration and SMP.  It eliminates the hypercall page by trapping the UD
> > exception that would occur if you used the wrong hypercall instruction for the
> > underlying architecture and replacing it with the right one lazily.
> >   
> 
> I guess it would be pretty rude/unlikely for these opcodes to get reused
> in other implementations...  But couldn't you make the page trap
> instead, rather than relying on an instruction fault?

That's a pain for inline hypercalls tho.  I was planning on moving
lguest to this model (which is interesting, because AFAICT this insn
will cause a #UD or #GP depending on whether VT is supported on this box
so I have to look for both).

Cheers,
Rusty.

