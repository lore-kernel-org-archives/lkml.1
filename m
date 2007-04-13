Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbXDML3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbXDML3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 07:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXDML3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 07:29:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbXDML3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 07:29:09 -0400
To: Keir Fraser <keir@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Chris Wright <chrisw@sous-sol.org>,
       David Rientjes <rientjes@google.com>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] i386 - pte update optimizations
References: <461EE9E5.6060403@vmware.com> <C2450C95.D3F6%keir@xensource.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 13 Apr 2007 14:27:09 +0200
In-Reply-To: <C2450C95.D3F6%keir@xensource.com>
Message-ID: <p738xcw7942.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser <keir@xensource.com> writes:

> On 13/4/07 03:24, "Zachary Amsden" <zach@vmware.com> wrote:
> 
> >> You do know that P6 and higher don't do locked bus references as long
> >> as the value is in the cache, right?
> > 
> > Yes.  Even then, last time I clocked instructions, xchg was still slower
> > than read / write, although I could be misremembering.  And it's not
> > totally clear that they will always be in cached state, however, and for
> > SMP, we still want to drop the implicit lock in cases where the
> > processor might not know they are cached exclusive, but we know there
> > are no other racing users.  And there are plenty of old processors out
> > there to still make it worthwhile.
> 
> LOCKed instruction suck really badly on the netburst microarchitecture (like
> factor of 10x, or not far off). I think it's probably because of their side
> effect of serialising memory accesses, causing horrible pipeline stalls.

Unfortunately they tend to be HyperThreaded usually (except for early ones 
and Celerons) and need the LOCK anyways.

-Andi
