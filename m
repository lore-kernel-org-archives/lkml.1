Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbZDIFuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbZDIFuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZDIFuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:50:08 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:48071 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbZDIFuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:50:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18909.35969.369573.720803@cargo.ozlabs.ibm.com>
Date: Thu, 9 Apr 2009 15:49:53 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: powerpc: add nmi_enter/nmi_exit calls
In-Reply-To: <20090409052002.GE5352@elte.hu>
References: <18909.31952.873098.336615@cargo.ozlabs.ibm.com>
	<20090409052002.GE5352@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> I'm wondering, what was the real impact? Was it a crash or some 
> other misbehavior? This impact line:
> 
> 	Impact: powerpc bug fix
> 
> is a bit too generic to be useful in practice. Something like:
> 
> 	Impact: fix stuck NMIs on powerpc
> 	Impact: fix NMI crash on powerpc
> 
> would have been more descriptive about the real, hands-on impact of 
> this patch.

I was looking at Peter's patches and I noticed he used in_nmi(), and I
wondered "what's that?", so I went looking and found it, and realized
that I needed to be calling nmi_enter/exit for it to work.  I never
actually booted a kernel that had the patch to use in_nmi() but not my
patch to call nmi_enter/exit.

The impact would have been that in_nmi() always returned 0, so I
expect that I would have seen deadlocks and/or memory corruption had I
booted a kernel without my fix.

Paul.
