Return-Path: <linux-kernel-owner+w=401wt.eu-S936914AbYEBUqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936914AbYEBUqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936816AbYEBUqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:46:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44719 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936815AbYEBUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:46:14 -0400
Subject: Re: 'global' rq->clock (was Re: Horrendous Audio Stutter - current
	git)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Frans Pop <elendil@planet.nl>,
       Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <3d8471ca0805021338x7cde7d1fwbbb58a6c65a1349d@mail.gmail.com>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209740523.4776.1.camel@marge.simson.net>
	 <200805021749.10205.elendil@planet.nl>
	 <200805022053.24779.elendil@planet.nl>
	 <1209756423.4693.8.camel@marge.simson.net> <1209758186.6929.18.camel@lappy>
	 <3d8471ca0805021338x7cde7d1fwbbb58a6c65a1349d@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 22:46:05 +0200
Message-Id: <1209761165.6929.25.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 22:38 +0200, Guillaume Chazarain wrote:
> On Fri, May 2, 2008 at 9:56 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >  Let me try and come up with something slightly less horrible
> 
> Does this obsolete Ingo's "sched: make cpu_clock() globally synchronous"?
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=27ec4407790d075c325e1f4da0a19c56953cce23
> 
> My laptop is UP, so I cannot test this :-(


It doesn't, I'm just throwing around code/ideas.

We should probably come up with some clock lib that builds the various
clocks: rq->clock and cpu_clock() from sched_clock() depending on some
architecture supplied hints.

We can toss most of this code on archs like power64, sparc64 and s390x
which have stable clocks. It just seems wrong to do all this on these
archs, but don't have much choice on x86.






