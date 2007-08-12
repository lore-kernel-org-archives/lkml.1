Return-Path: <linux-kernel-owner+w=401wt.eu-S933812AbXHLQXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbXHLQXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 12:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXHLQXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 12:23:47 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:54213 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbXHLQXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 12:23:46 -0400
Date: Sun, 12 Aug 2007 12:23:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, mingo@redhat.com
Subject: Re: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on 80386 and 80486
Message-ID: <20070812162341.GA30075@Krystal>
References: <20070812145434.520271946@polymtl.ca> <20070812145834.542290892@polymtl.ca> <Pine.LNX.4.64.0708121750090.28963@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708121750090.28963@fbirervta.pbzchgretzou.qr>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:20:24 up 13 days, 16:39,  2 users,  load average: 1.69, 2.47, 2.99
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Engelhardt (jengelh@computergmbh.de) wrote:
> 
> On Aug 12 2007 10:54, Mathieu Desnoyers wrote:
> 
> >Date: Sun, 12 Aug 2007 10:54:35 -0400
> >From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> >To:  <akpm@linux-foundation.org>,  <linux-kernel@vger.kernel.org>
> >Cc: Christoph Lameter <clameter@sgi.com>,
> >    Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,  <mingo@redhat.com>
> >Subject: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on 80386 and
> >     80486
> >
> >Actually, on 386, cmpxchg and cmpxchg_local fall back on
> >cmpxchg_386_u8/16/32: it disables interruptions around non atomic
> >updates to mimic the cmpxchg behavior.
> >
> >The comment:
> >/* Poor man's cmpxchg for 386. Unsuitable for SMP */
> >
> >already present in cmpxchg_386_u32 tells much about how this cmpxchg
> >implementation should not be used in a SMP context. However, the cmpxchg_local
> >can perfectly use this fallback, since it only needs to be atomic wrt the local
> >cpu.
> >
> >This patch adds a cmpxchg_486_u64 and uses it as a fallback for cmpxchg64
> >and cmpxchg64_local on 80386 and 80486.
> 
> hm, but why is it called cmpxchg_486 when the other functions are called
> cmpxchg_386?
> 

Because the standard cmpxchg is missing only on  386, but cmpxchg8b is
missing both on 386 and 486.

Citing Intel's Instruction set reference:

cmpxchg:
This instruction is not supported on Intel processors earlier than the
Intel486 processors.

cmpxchg8b:
This instruction encoding is not supported on Intel processors earlier
than the Pentium processors.

Mathieu

> 
> 	Jan
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
