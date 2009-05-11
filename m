Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbZEKUGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbZEKUGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758766AbZEKUGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:06:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41177 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbZEKUGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:06:09 -0400
Message-ID: <4A08852E.4010504@garzik.org>
Date: Mon, 11 May 2009 16:06:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [PATCH 1/2 v2] kernel/{sched,smp}.c: fix static decl prior to
 struct declaration
References: <20090508184838.GA11157@havoc.gtf.org> <20090508193841.GA13831@havoc.gtf.org> <20090511112648.GA27226@elte.hu>
In-Reply-To: <20090511112648.GA27226@elte.hu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> -tip testing found this build bug:
> 
> kernel/sched.c: In function ‘root_task_group_empty’:
> kernel/sched.c:312: error: ‘root_task_group’ undeclared (first use in this function)
> kernel/sched.c:312: error: (Each undeclared identifier is reported only once
> kernel/sched.c:312: error: for each function it appears in.)
> 
> config attached.

Fixed and resent.

What a rat's nest of ifdefs!  root_task_group is outside 
CONFIG_USER_SCHED, and so I kept that property in patch v3.

However, its definition in kernel/sched.h is conditional on 
CONFIG_USER_SCHED, even though root_task_group_empty() may exist outside 
of CONFIG_USER_SCHED, and root_task_group is referenced vi
CONFIG_FAIR_GROUP_SCHED || CONFIG_RT_GROUP_SCHED.

Starting to wish I had never patched this code in the first place (that 
barb is directed at the code, not you...)

	Jeff



