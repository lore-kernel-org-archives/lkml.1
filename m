Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYELTcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYELTcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYELTck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:32:40 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44054 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYELTcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:32:39 -0400
To: rjw@sisk.pl
CC: mingo@elte.hu, parag.warudkar@gmail.com, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
In-reply-to: <200805122129.15149.rjw@sisk.pl>
Subject: Re: [Bug #10640] audio skipping on 2.6.26-rc1
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <loom.20080511T220943-718@post.gmane.org> <20080512075252.GB26074@elte.hu> <200805122129.15149.rjw@sisk.pl>
Message-Id: <E1Jvdkw-0007pk-9i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 May 2008 21:32:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > * Parag Warudkar <parag.warudkar@gmail.com> wrote:
> > 
> > > Rafael J. Wysocki <rjw <at> sisk.pl> writes:
> > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10640
> > > > Subject		: audio skipping on 2.6.26-rc1
> > > > Submitter	: Miklos Szeredi <miklos <at> szeredi.hu>
> > > > Date		: 2008-05-07 7:56 (5 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=121014707707781&w=2
> > > > Handled-By	: Ingo Molnar <mingo <at> elte.hu>
> > > 
> > > This is a duplicate of [Bug #10616] Horrendous Audio Stutter - current 
> > > git .
> > 
> > that should be resolved via your patch which i pushed upstream (commit 
> > v2.6.26-rc1-83-gaac6abc), which marks group scheduling experimental and 
> > non-default.
> > 
> > i think the audio skipping from Miklos, if it does not go away with 
> > disabling group scheduling, might also be solved by:
> > 
> >  - commit v2.6.26-rc1-181-g4615112 ("sched: fix weight calculations") 
> >    from Mike.
> > 
> >  - or by commit v2.6.26-rc1-82-g3e51f33 from Peter ("sched: add optional 
> >    support for CONFIG_HAVE_UNSTABLE_SCHED_CLOCK") which makes the 
> >    scheduler clock more reliable [and hence produce no artificial 
> >    latencies] on NOHZ
> > 
> >  - or by commit v2.6.26-rc1-66-ga992241 from Peter ("sched: fix 
> >    normalized sleeper").
> 
> Miklos, can you please verify if the problem is present in 2.6.26-rc2?

Yep, disabling group sched fixed it.

Miklos
