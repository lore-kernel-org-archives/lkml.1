Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYLPAt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYLPAt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 19:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbYLPAtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 19:49:49 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38378 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbYLPAts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 19:49:48 -0500
To: rjw@sisk.pl
CC: a.p.zijlstra@chello.nl, efault@gmx.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       miklos@szeredi.hu
In-reply-to: <T1gm2CtAHBF.A.u6G.g4_QJB@chimera> (rjw@sisk.pl)
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera> <T1gm2CtAHBF.A.u6G.g4_QJB@chimera>
Message-Id: <E1LCO85-0000rR-Br@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 16 Dec 2008 01:49:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
> Subject		: uml is very slow on 2.6.28 host
> Submitter	: Miklos Szeredi <miklos@szeredi.hu>
> Date		: 2008-12-12 9:35 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4

I did a bisection, and this is the commit which is responsible:

  commit 464b75273f64be7c81fee975bd6ca9593df3427b
  Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
  Date:   Fri Oct 24 11:06:15 2008 +0200
  
      sched: re-instate vruntime based wakeup preemption
  
      The advantage is that vruntime based wakeup preemption has a better
      conceptual model. Here wakeup_gran = 0 means: preempt when 'fair'.
      Therefore wakeup_gran is the granularity of unfairness we allow in order
      to make progress.
  
      Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
      Acked-by: Mike Galbraith <efault@gmx.de>
      Signed-off-by: Ingo Molnar <mingo@elte.hu>

Miklos
