Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbZJXIap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbZJXIap (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 04:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZJXIao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 04:30:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36543 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZJXIan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 04:30:43 -0400
Date: Sat, 24 Oct 2009 10:30:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Marti Raudsepp <marti@juffo.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and
	autodetect
Message-ID: <20091024083031.GB20575@elte.hu>
References: <1256330234-14079-1-git-send-email-marti@juffo.org> <20091023210231.GC8356@elte.hu> <1256334501-15755-1-git-send-email-marti@juffo.org> <193b0f820910231807t35f8b462r1f92e28492b780e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <193b0f820910231807t35f8b462r1f92e28492b780e2@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lucas De Marchi <lucas.de.marchi@gmail.com> wrote:

> On Fri, Oct 23, 2009 at 19:48, Marti Raudsepp <marti@juffo.org> wrote:
> > On Sat, Oct 24, 2009 at 12:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> Mind doing a small change:
> >>
> >> I think we want a small cleanup here: a perf_elf_begin() wrapper in a
> >> header file to hide this #ifdef. (That's how Git wraps environmental
> >> libraries as well.)
> >
> Why don't you do something like?:
> 
> #ifdef LIBELF_NO_MMAP
> #define ELF_C_READ_MMAP ELF_C_READ
> #endif
> + changes to Makefile
> 
> or:
> 
> #ifndef ELF_C_READ_MMAP
> #define ELF_C_READ_MMAP ELF_C_READ
> #endif

Makes sense - i'd suggest to prefix it with PERF_ in that case, to make 
sure all callsites are aware of the wrapped nature of this constant. 

I.e. something like this:

/*
 * libelf 0.8 and earlier do not support ELF_C_READ_MMAP;
 * for newer versions we can use mmap to reduce memory usage:
 */
#ifndef ELF_C_READ_MMAP
# define PERF_ELF_C_READ_MMAP ELF_C_READ
#endif

	Ingo
