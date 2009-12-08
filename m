Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZLHHTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZLHHTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZLHHTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:19:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46700 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZLHHTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:19:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v6] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com, Bryan Donlan <bdonlan@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>, Timo Sirainen <tss@iki.fi>,
       WANG Cong <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091208065725.GA21340@elte.hu>
References: <3e8340490912072228m70368001v2487bd745ff208b3@mail.gmail.com> <20091208065725.GA21340@elte.hu>
Message-Id: <20091208161838.B5BD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Dec 2009 16:19:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Bryan Donlan <bdonlan@gmail.com> wrote:
> 
> > On Tue, Dec 8, 2009 at 12:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > >
> > >> > The feature looks useful, but the choice of a prctl as an API is strange
> > >> > - it limits us to the current task only - while the ability to set
> > >> > arguments for another task looks a more generic (and potentially more
> > >> > useful) solution.
> > >>
> > >> No. It's impossible.
> > >> /proc/{pid}/cmdline read user process's memory. iow, this prctl() don't
> > >> receive string, it receive virtual address itself. [...]
> > >
> > > it's not 'impossible' at all, you yourself mention ptrace:
> > 
> > If another process is going to use ptrace to inject the cmdline string 
> > into the victim's address space, it can also temporarily hijack a 
> > thread to run prctl() on its behalf...
> 
> That's exactly the point i made. There's no reason not to offer the API 
> i suggested as long as permissions are checked (as usual) - because 
> ptrace already allows this (and more).

Confused.

I think ptrace don't solve the issue of explained my patch description.
currently, proc title pointer is held by mm_struct (i.e. kernel), but string
isself is in userland.
then, if we want to use long proc tile, we need following three steps.
  1. make new userland space
  2. write proc title to it
  3. change proc title pointer in kernel

ptrace can only change exist userland memory. iow, it can only 
write same length string.
To expand another task's virtual address space makes lots trouble rather than
solving issue.

argv[0] and /proc/pid/cmdline are already special. generic api don't fit it, I think.


