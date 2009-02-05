Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZBEVcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZBEVcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZBEVco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:32:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZBEVcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:32:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Kaz Kylheku <kkylheku@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
In-Reply-To: Oleg Nesterov's message of  Thursday, 5 February 2009 17:15:44 +0100 <20090205161544.GA24799@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
	<20090201174159.4a52e15c.akpm@linux-foundation.org>
	<20090202064509.GA20237@redhat.com>
	<3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
	<20090202165606.GA13346@redhat.com>
	<20090205030553.49650FC381@magilla.sf.frob.com>
	<3f43f78b0902042055p37ff9ab2u84840273b34c7373@mail.gmail.com>
	<20090205161544.GA24799@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090205212234.934D1FC381@magilla.sf.frob.com>
Date: Thu,  5 Feb 2009 13:22:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes we have the bug, and wait_task_stopped() should be fixed. But it is
> buggy anyway, even if we delay the death of the main thread. But I also
> think we shouldn't.

Sorry, I'd missed the actual bug report among all the tangential verbiage.
I wrote this test case for it.  Is there any problem other than this one?


Thanks,
Roland

==========

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <pthread.h>
#include <assert.h>

static void *
thfunc (void *arg)
{
  sleep (2);
  puts ("stopping");
  raise (SIGSTOP);
  puts ("resumed");
  exit (0);
}

int
main (void)
{
  pthread_t th;
  int rc = pthread_create (&th, NULL, &thfunc, NULL);
  assert_perror (rc);
  pthread_exit (0);
  /*NOTREACHED*/
  return 1;
}
