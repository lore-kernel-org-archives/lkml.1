Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbXLDMvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbXLDMvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXLDMvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:51:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37161 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbXLDMvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:51:24 -0500
Date: Tue, 4 Dec 2007 13:51:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: [PATCH] fix x86-32 early fixmap initialization.
Message-ID: <20071204125101.GA31590@elte.hu>
References: <47520F37.20657.4A6846F1@pageexec.freemail.hu> <m163zh5181.fsf@ebiederm.dsl.xmission.com> <86802c440712011824v4fdac3c4pfaf2f4d5ce93fe18@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440712011824v4fdac3c4pfaf2f4d5ce93fe18@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Dec 1, 2007 5:34 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> > pageexec@freemail.hu writes:
> >
> > > hello,
> > >
> > > i've just noticed that the chunk in i386/kernel/head.S ended up in a
> > > weird place, namely, it's not going to be executed as it's just after
> > > a 'jmp 3f' and before startup_32_smp, probably not what you intended.
> > > on a sidenote, the whole thing can be done in a single insn, like:
> > >
> > > movl $(swapper_pg_pmd - __PAGE_OFFSET + 0x067), (swapper_pg_dir -
> > > __PAGE_OFFSET+ 4092)
> > >
> > > PS: your email address ebiderman@xmisson.com in the commit seems to
> > > be wrong as well.
> >
> > Yes.  YH refresh one of my old patches and apparently got my email
> > address wrong.
> >
> > Thanks for the reminder I thought we had fixed this problem a while 
> > ago.
> 
> i sent fix to andrew and andi. but it seems they missed it.

ok, this one is now upstream, it's in -rc4:

 ------------->
 commit 17d57a9206b4de6ad082ac9f2d2346985abbd2aa
 Author: Eric W. Biederman <ebiederm@xmission.com>
 Date:   Sat Dec 1 18:34:06 2007 -0700

     x86: fix x86-32 early fixmap initialization.

     pageexec@freemail.hu writes:

