Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227Ab0A2G44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab0A2G44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661Ab0A2G44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:56:56 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42558 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0A2G4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:56:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=VyD++GDFG32tn3tDTKClaDZU7yMXPGPl0qM7dKJoUibi9GKdeeycWwVf/NOas50Vic
         kO6LfxWTSktU9CxCNSy8DzzZ2HvU/zsmO3H/1hN8gLyWxHOzj/jbpfNRo9OL6eE7u+w4
         K1x6WSVWw3rQT00A2oKwOJVQCSvH4/swbT/kI=
MIME-Version: 1.0
Date: Fri, 29 Jan 2010 14:56:55 +0800
Message-ID: <2674af741001282256l3058d356p752b49c024c47e1c@mail.gmail.com>
Subject: [RFC 0/2 PATCH] remove member rt_se from struct rt_rq
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, rusty <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

member rt_se of struct rt_rq is a duplicate of tg->rt_se[cpu].
So we can remove one of them. After checking CFS, I think
rt_rq->rt_se can be removed for some kinds of consistence.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Yong Zhang (2):
      sched: change usage of rt_rq->rt_se to rt_rq->tg->rt_se[cpu]
      sched: remove member rt_se from struct rt_rq

 kernel/sched.c    |    2 --
 kernel/sched_rt.c |   10 ++++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)
