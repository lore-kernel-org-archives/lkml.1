Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZAJGq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZAJGq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZAJGqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:46:17 -0500
Received: from ozlabs.org ([203.10.76.45]:41672 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZAJGqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:46:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: regarding the x86_64 zero-based percpu patches
Date: Sat, 10 Jan 2009 17:16:02 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <49649814.4040005@kernel.org> <20090107120225.GA30651@elte.hu> <49649C65.6000706@kernel.org>
In-Reply-To: <49649C65.6000706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101716.04220.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009 22:43:25 Tejun Heo wrote:
> IIUC, Rusty is somewhat leaning toward limiting per-cpu area and using
> static allocator. (right?)

Not quite.  Six years ago I didn't do "proper" dynamic per-cpu because of
this lack-of-expanding problem.  I expected (myself or someone else) would
fix that and the current temporary solution would be replaced.

But Christoph showed that even in a limited form it can be used for more
than static per-cpu vars and such vars in modules.  (It's also in dire need
of a cleanup, since there have been several abortive changes made in the last
few years).

> As I was trying to do more stuff per-cpu
> (not putting a lot of stuff into per-cpu area but even with small
> things limited per-cpu area poses scalability problems), cpu_alloc
> seems to fit the bill better.

Unfortunately cpu_alloc didn't solve this problem either.

We need to grow the areas, but for NUMA layouts it's non-trivial.  I don't
like the idea of remapping: one TLB entry per page per cpu is going to suck.
Finding pages which are "congruent" with the original percpu pages is more
promising, but it will almost certainly need to elbow pages out the way to
have a chance of succeeding on a real system.

> Anyways, I think it's worthwhile to listen what people have on mind
> regarding how per-cpu stuff should proceed.

Absolutely.

Thanks,
Rusty.
