Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZJNGVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZJNGVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZJNGVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:21:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56428 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbZJNGVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:21:47 -0400
Date: Wed, 14 Oct 2009 08:20:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@ORACLE.COM>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf tools: Fix the NO_64BIT build on pure
	64-bit systems
Message-ID: <20091014062052.GD784@elte.hu>
References: <tip-55621ccf2b7a8afe39df8c80f55b28424fd07d13@git.kernel.org> <20091013140915.96cfe060.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013140915.96cfe060.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@ORACLE.COM> wrote:

> On Mon, 12 Oct 2009 08:34:16 GMT tip-bot for Ingo Molnar wrote:
> 
> > Commit-ID:  55621ccf2b7a8afe39df8c80f55b28424fd07d13
> > Gitweb:     http://git.kernel.org/tip/55621ccf2b7a8afe39df8c80f55b28424fd07d13
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Mon, 12 Oct 2009 09:57:25 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 12 Oct 2009 10:00:27 +0200
> > 
> > perf tools: Fix the NO_64BIT build on pure 64-bit systems
> > 
> > Randy Dunlap reported that 'make NO_64BIT=1' fails to build
> > a pure 32-b it binary on 64-bit/64-bit x86 systems.
> > 
> > The reason is that we dont pass in the -m32 and GCC defaults
> > to -m64.
> > 
> > So pass it in - and also extend the warning message about libelf
> > dependencies - glibc-dev[el] is needed as well beyond the libelf
> > library.
> 
> Ingo, thanks, I finally got this working, after installing more 32-bit
> libs etc., like Kyle said that I would need to do.
> 
> The error message is still a little misleading/confusing:
> Makefile:426: *** No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el].  Stop.
> 
> when elfutils-libelf-devel.i586 is installed but glibc-devel.i[56]86 is not
> installed.  gcc failed with:
> In file included from /usr/include/features.h:376,
>                  from /usr/include/sys/types.h:27,
>                  from /usr/include/libelf.h:53,
>                  from elfdeveltest.c:1:
> /usr/include/gnu/stubs.h:7:27: error: gnu/stubs-32.h: No such file or directory

Why is it misleading? It says it very clearly that you need to install 
both:

  please install libelf-dev/elfutils-libelf-devel and glibc-dev[el].  Stop.

	Ingo
