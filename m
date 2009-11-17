Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZKQJXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZKQJXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZKQJXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:23:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34977 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbZKQJXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:23:37 -0500
Date: Tue, 17 Nov 2009 10:23:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: support static build
Message-ID: <20091117092331.GA23585@elte.hu>
References: <20091029152002.GA5406@redhat.com>
 <20091104110604.GE13194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104110604.GE13194@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Michael S. Tsirkin <mst@redhat.com> wrote:
> 
> > This makes it possible to build perf statically, by performing make 
> > LDFLAGS=-static
> >
> > Since static libraries are only searched in the order they are 
> > specified, move library list from LDFLAGS to EXTLIBS, so that they are 
> > put at the end of linker command line.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > Changes in v2: updated to latest tip.
> 
> The Makefile changed again so your v2 patch is conflicting too - mind 
> updating it to latest -tip?

i've applied your patch to latest -tip and resolved the conflicts 
manually. Normal build works, but static one does not yet:

  aldebaran:~/linux/linux/tools/perf> make -j LDFLAGS=-static
  Makefile:484: *** No libelf.h/libelf found, please install 
  libelf-dev/elfutils-libelf-devel and glibc-dev[el].  Stop.

mind double checking my changes in

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
