Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYFIGhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYFIGhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbYFIGh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:37:29 -0400
Received: from mail1.aster.pl ([212.76.33.23]:2889 "EHLO mail1.aster.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbYFIGh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:37:27 -0400
From: Jakub Jozwicki <jozwicki@aster.pl>
To: linux-kernel@vger.kernel.org
Subject: Re: sched_yield() on 2.6.25
Date: Mon, 9 Jun 2008 08:37:24 +0200
User-Agent: KMail/1.9.7
References: <fa.5iKTy3xTJkKWZLGio+GIHXi3+0o@ifi.uio.no> <484C588A.9090800@shaw.ca>
In-Reply-To: <484C588A.9090800@shaw.ca>
Cc: Robert Hancock <hancockr@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806090837.25121.jozwicki@aster.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Is this behavior expected?
>
> The behavior of sched_yield with SCHED_OTHER processes has changed
> several times with Linux over the years, since its behavior is not
> defined by standards, so it's really "whatever the scheduler feels like
> doing". The behavior is only defined with realtime scheduling
> (SCHED_FIFO or SCHED_OTHER).
>
> Generally, it's a mistake to assume specific timing behavior from
> sched_yied for SCHED_OTHER processes.

>From the man sched_yield:

A  process  can  relinquish  the  processor  voluntarily without blocking by
calling sched_yield().  The process will then be moved to the  end  of  the 
queue  for  its static priority and a new process gets to run.

and also IEEE/Open Group:
http://www.opengroup.org/onlinepubs/000095399/functions/sched_yield.html

>>	pthread_mutex_lock(&mutex);
> > 	th = pthread_self();
> > 	if (pthread_equal(th,last_th)) {
> > 	    pthread_mutex_unlock(&mutex);
> > 	    sched_yield();
> > 	    continue;

Here with SCHED_OTHER sched_yield for the first 100-200 times does nothing.
Should the man be updated?

Regards,
Jakub
