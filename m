Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbZLIJKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbZLIJKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZLIJKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:10:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59479 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZLIJKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:10:31 -0500
Date: Wed, 9 Dec 2009 10:10:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, Ulrich Drepper <drepper@redhat.com>,
       Timo Sirainen <tss@iki.fi>, WANG Cong <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6] Added PR_SET_PROCTITLE_AREA option for prctl()
Message-ID: <20091209091023.GD5129@elte.hu>
References: <3e8340490912072228m70368001v2487bd745ff208b3@mail.gmail.com>
 <20091208065725.GA21340@elte.hu>
 <20091208161838.B5BD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208161838.B5BD.A69D9226@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > 
> > * Bryan Donlan <bdonlan@gmail.com> wrote:
> > 
> > > On Tue, Dec 8, 2009 at 12:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > > >
> > > > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > >
> > > >> > The feature looks useful, but the choice of a prctl as an API is strange
> > > >> > - it limits us to the current task only - while the ability to set
> > > >> > arguments for another task looks a more generic (and potentially more
> > > >> > useful) solution.
> > > >>
> > > >> No. It's impossible.
> > > >> /proc/{pid}/cmdline read user process's memory. iow, this prctl() don't
> > > >> receive string, it receive virtual address itself. [...]
> > > >
> > > > it's not 'impossible' at all, you yourself mention ptrace:
> > > 
> > > If another process is going to use ptrace to inject the cmdline string 
> > > into the victim's address space, it can also temporarily hijack a 
> > > thread to run prctl() on its behalf...
> > 
> > That's exactly the point i made. There's no reason not to offer the API 
> > i suggested as long as permissions are checked (as usual) - because 
> > ptrace already allows this (and more).
> 
> Confused.
> 
> I think ptrace don't solve the issue of explained my patch description.

it doesnt. By 'this' i meant the security aspect. ptrace can already do 
almost arbitrary alteration to any task's state.

	Ingo
