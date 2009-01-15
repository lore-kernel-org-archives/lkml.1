Return-Path: <linux-kernel-owner+w=401wt.eu-S934461AbZAOVBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461AbZAOVBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933364AbZAOU1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:27:51 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:36286 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361AbZAOU1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:27:50 -0500
Date: Thu, 15 Jan 2009 14:26:26 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: regarding the x86_64 zero-based percpu patches
In-Reply-To: <200901151219.03403.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0901151424360.28153@quilx.com>
References: <49649814.4040005@kernel.org> <496C071F.3000408@kernel.org>
 <m1k58zx305.fsf@frodo.ebiederm.org> <200901151219.03403.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Rusty Russell wrote:

> On Tuesday 13 January 2009 14:37:38 Eric W. Biederman wrote:
> > It isn't incompatible with a per-cpu virtual mapping.  It allows the
> > possibility of each cpu reusing the same chunk of virtual address
> > space for per cpu memory.
>
> This can be done (IA64 does it today), but it's not generically useful.
> You can use it to frob a few simple values, but it means you can't store
> any pointers, and that just doesn't fly in general kernel code.

Well if we can have some surelty that we are not going to store pointers
to percpu data anywhere then this would work.

> > I think it would be nice if the percpu area could grow and would not be
> > a fixed size at boot time, I'm not particularly convinced it has to.
>
> I used to be convinced it had to grow, but Christoph showed otherwise.
> Nonetheless, it's an annoying restriction which is going to bite us in
> the ass repeatedly as coders use per_cpu on random sizes.

Not exactly. I implemented a minimal version that had only limited use. I
was fully intending to add further bloat to have dynamically extendable
percpu areas at the end. Most of the early cpu_alloc patchsets already
include that code.

