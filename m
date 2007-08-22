Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbXHVT7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbXHVT7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762900AbXHVT7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:59:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:36621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762881AbXHVT7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:59:21 -0400
Date: Wed, 22 Aug 2007 22:53:11 +0200
From: Andi Kleen <ak@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: 2.6.23-rc3-mm1
Message-ID: <20070822205311.GH8058@bingen.suse.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822110348.8fd6a937.randy.dunlap@oracle.com> <20070822113211.9ac85162.akpm@linux-foundation.org> <20070822193857.GC8058@bingen.suse.de> <20070822121731.011cd263.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822121731.011cd263.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 12:17:31PM -0700, Randy Dunlap wrote:
> > Why does that compiler not know __builtin_abs?
> 
> I dunno:
> 
> > gcc --version
> gcc (GCC) 4.1.0 (SUSE Linux)

Hmm I use the same compiler from SUSE10.2 and it works for me (with both
mm and only my tree applied) 

Ok mm fails with some errors in the wireless drivers but with 
wireless disabled it compiles.

When you compile a simple test program like

main() { printf("%lu\n", __builtin_labs(-1)); }

does it work?


> > > One wonders why x86_64-mm-unwinder.patch has an open-coded call to
> > > __builtin_labs(), when include/linux/kernel.h:abs() should do a fine job.

Andrew, I actually checked that and the abs() there is just abs()
not a labs(). So it wouldn't work on 64bit platform.

We could opencode it of course, but __builtin_labs should be really 
there.

-Andi
