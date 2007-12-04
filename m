Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbXLDViU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbXLDViU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXLDViH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:38:07 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:44692 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbXLDViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:38:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAP9XVUdMROHU/2dsb2JhbACBWg
Date: Tue, 4 Dec 2007 16:38:01 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paulo Marques <pmarques@grupopie.com>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [-mm PATCH] kallsyms should prefer non weak symbols
Message-ID: <20071204213801.GA8543@Krystal>
References: <4755BA14.8060706@grupopie.com> <20071204131746.ede01c65.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071204131746.ede01c65.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:35:13 up 31 days,  2:40,  6 users,  load average: 5.59, 4.26,
	2.26
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 04 Dec 2007 20:35:32 +0000
> Paulo Marques <pmarques@grupopie.com> wrote:
> 
> > When resolving symbol names from addresses with aliased symbol names, 
> > kallsyms_lookup always returns the first symbol, even if it is a weak 
> > symbol.
> > 
> > This patch changes this by sorting the symbols with the weak symbols 
> > last before feeding them to the kernel. This way the kernel runtime 
> > isn't changed at all, only the kallsyms build system is changed.
> > 
> > Another side effect is that the symbols get sorted by address, too. So, 
> > even if future binutils version have some bug in "nm" that makes it fail 
> > to correctly sort symbols by address, the kernel won't be affected by this.
> > 
> > 
> 
> I don't understand the reason for making this change.
> 

I created a module in LTTng that uses kallsyms to get the symbol
corresponding to a specific system call address. Unfortunately, all the
unimplemented syscalls were all referring to the (same) weak symbol
identifying an unrelated system call rather that sys_ni (or whatever
non-weak symbol would be expected). Kallsyms was dumbly returning the
first symbol that matched.

This patch makes sure kallsyms returns the non-weak symbol when there is
one, which seems to be the expected result.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
