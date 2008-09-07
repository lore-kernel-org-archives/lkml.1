Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbYIGJfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbYIGJfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 05:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYIGJfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 05:35:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYIGJfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 05:35:02 -0400
Subject: Re: nice and hyperthreading on atom
From: Peter Zijlstra <peterz@infradead.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Phil Endecott <phil_wueww_endecott@chezphil.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <a36005b50809061130t1b510b7eu3f7336ebeef4f36b@mail.gmail.com>
References: <1220715811849@dmwebmail.dmwebmail.chezphil.org>
	 <20080906094248.5930911a@infradead.org>
	 <a36005b50809061130t1b510b7eu3f7336ebeef4f36b@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 11:34:58 +0200
Message-Id: <1220780098.8687.40.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-06 at 11:30 -0700, Ulrich Drepper wrote:
> On Sat, Sep 6, 2008 at 9:42 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> > As an OS one COULD decide to just not schedule the nice task at all,
> > but then, especially on atom where HT has a high efficiency, your cpu
> > is mostly idle ...
> 
> One thread being idle is even on Atom the right thing to do in some
> situations.  If you have processes which, when HT is used, experience
> high pressure on the common cache(s) then you should not schedule them
> together.  We can theoretically find out whether this is the case
> using the PMCs.  With perfmon2 hopefully on the horizon soon it might
> actually be possible to automatically make these measurements.
> 
> There is another aspect I talked to Peter about already.  We really
> want concurrent threat scheduling in some cases.  For the
> implementation of helper threads you don't want two threads to be
> scheduled independently, you want them to be scheduled on a HT pair.
> Currently this isn't possible except by pinning them to fixed threads.
>  We really want to have a new way to express this type of scheduling
> (Peter, how did you call it?)

Really helps if you make sure I'm on the CC ;-)

I think I called it something like affinity grouping - but I'm still a
bit scared of the bin-packing issues involved - those will really mess
up the already complex balancing rules.

