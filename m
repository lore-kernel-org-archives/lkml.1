Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbZKMXZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbZKMXZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932447AbZKMXZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:25:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbZKMXZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:25:06 -0500
Date: Sat, 14 Nov 2009 00:24:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH -tip 1/3] Pass mm->flags to binfmt core_dump for bitflag
 consistency
Message-ID: <20091113232457.GC21666@elte.hu>
References: <20091113225226.15079.90813.stgit@harusame>
 <20091113150904.56c15910.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113150904.56c15910.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 13 Nov 2009 17:52:27 -0500
> Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Pass mm->flags to binfmt core_dump for bitflag consistency.
> > Since mm->flags bit flags is not protected by locks, it will be
> > changed while dumping core. This patch copies mm->flags to a
> > mm_flags local variable at the beginning of do_coredump() and
> > use it while dumping. mm_flags also includes dump_filter which
> > filters elf sections from core file in elf_core_dump().
> > So, this patch also passes mm_flags to each binfmt->core_dump().
> 
> I can kind-of guess the answer, but it would be much more reliable if
> we were to hear this from yourself:
> 
>   Why did you write this patch?  What problem is being observed?

i'm not Masami so i'm only guessing that while writing the tracepoint a 
race got noticed but that otherwise there's no big practical effect, 
'just' a cleanliness problem fixed.

	Ingo
