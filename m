Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbZJLTYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbZJLTYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbZJLTYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:24:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757694AbZJLTYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:24:22 -0400
Date: Mon, 12 Oct 2009 12:22:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, linux-api@vger.kernel.org,
       Timo Sirainen <tss@iki.fi>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Message-Id: <20091012122246.a941013b.akpm@linux-foundation.org>
In-Reply-To: <20091013022335.C741.A69D9226@jp.fujitsu.com>
References: <2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com>
	<20091009233935.1be0edf9.akpm@linux-foundation.org>
	<20091013022335.C741.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 04:03:45 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Start simple.  What's wrong with mutex_lock() on the reader and writer
> > sides?  rwsems might be OK too.
> > 
> > In both cases we should think about whether persistent readers can
> > block the writer excessively though.
> 
> I thought your mention seems reasonable. then I mesured various locking
> performance.
> 
> 		no-contention	read-read contetion	read-write contention
> w/o patch	4627 ms		 7575 ms		 N/A
> mutex		5717 ms		33872 ms (!)		14793 ms
> rw-semaphoe	6846 ms		10734 ms		36156 ms (!)
> seqlock		4754 ms		 7558 ms		 9373 ms
> 
> Umm, seqlock is significantly better than other.

Sure, but even the worst case there is 1,000,000 operations in 34
seconds (yes?). 33 microseconds for a /proc read while under a specific
local DoS attack is OK!

If so then all implementations are acceptable and we should choose the
simplest, most-obviously-correct one.


