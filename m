Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXCQPkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXCQPkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 11:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXCQPkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 11:40:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35465 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXCQPkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 11:40:07 -0400
Date: Sat, 17 Mar 2007 16:39:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: RSDL v0.31
Message-ID: <20070317153908.GA26036@elte.hu>
References: <200703042335.26785.a1426z@gawab.com> <200703170040.48316.kernel@kolivas.org> <1174059299.7886.25.camel@Homer.simpson.net> <200703170813.32594.kernel@kolivas.org> <1174084207.7009.9.camel@Homer.simpson.net> <45FBFC18.8060700@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <45FBFC18.8060700@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Rik van Riel <riel@redhat.com> wrote:

> The increased AIM7 throughput (and the other benchmark results) looked 
> very promising to me.
> 
> I wonder what we're doing wrong in the normal scheduler...

there's a relatively easy way to figure out whether it's related to the 
interactivity code: try AIM7 with SCHED_BATCH as well, to take most of 
the 'interactivity effects' out of the picture.

build the attached setbatch.c code and do "./setbatch $$" to change the 
shell to SCHED_BATCH (and all its future children will be SCHED_BATCH 
too).

	Ingo

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="setbatch.c"


/*
 * Set a given PID to be a SCHED_BATCH process.
 * 
 * Copyright (C) 2002 Ingo Molnar
 */
#include <time.h>
#include <stdio.h>
#include <sched.h>
#include <stdlib.h>
#include <sys/types.h>
#include <linux/unistd.h>

int main (int argc, char **argv)
{
	int pid, ret;
	struct sched_param p;

	p.sched_priority = 0;

	if (argc != 2) {
		printf("usage: setbatch <pid>\n");
		exit(-1);
	}
	pid = atol(argv[1]);

	ret = sched_setscheduler(pid, 3, &p);

	if (ret) {
		printf("could not set pid %d to SCHED_BATCH: err %d.\n", pid, ret);
		return -1;
	}
	printf("pid %d is SCHED_BATCH from now on.\n", pid);
	return 0;
}

--45Z9DzgjV8m4Oswq--
