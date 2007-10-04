Return-Path: <linux-kernel-owner+w=401wt.eu-S1760994AbXJDSaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760994AbXJDSaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXJDSaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:30:04 -0400
Received: from ns2.suse.de ([195.135.220.15]:50208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820AbXJDSaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:30:01 -0400
To: "Steven J. Hill" <sjhill@realitydiluted.com>
Cc: veerasena reddy <veerasena_b@yahoo.co.in>,
       linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: unresoved symbol _gp_disp
References: <230962.51223.qm@web8408.mail.in.yahoo.com>
	<20071004173928.GA32033@real.realitydiluted.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 04 Oct 2007 20:29:59 +0200
In-Reply-To: <20071004173928.GA32033@real.realitydiluted.com>
Message-ID: <p73k5q268d4.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Hill" <sjhill@realitydiluted.com> writes:

> > I have written a loadble module ( which gets complied
> > along with kernel) which does some floating point
> > operation.
> >  
> NO FLOATING POINT in the kernel PERIOD. Either use integer
> operations, or redo your software architecture and do the
> floating point in userspace.

You can use floating point; you just have to make sure to 
save the FP context explicitely and disable preemption. Details
on how to do this vary by architecture.

The problem is that FP code typically takes often a lot of CPU time
and it is quite antisocial to disable preemption for a long time
because that impacts real time latency for everybody.

Besides many uses can be relatively easily rewritten to fixed
point.

-Andi
