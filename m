Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYFIPFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYFIPFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYFIPE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:04:58 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:60907 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751575AbYFIPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:04:57 -0400
Subject: Re: sched_yield() on 2.6.25
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jakub Jozwicki <jozwicki@aster.pl>
Cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
In-Reply-To: <200806090837.25121.jozwicki@aster.pl>
References: <fa.5iKTy3xTJkKWZLGio+GIHXi3+0o@ifi.uio.no>
	 <484C588A.9090800@shaw.ca>  <200806090837.25121.jozwicki@aster.pl>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 17:04:53 +0200
Message-Id: <1213023893.23439.187.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 08:37 +0200, Jakub Jozwicki wrote:
> > > Is this behavior expected?
> >
> > The behavior of sched_yield with SCHED_OTHER processes has changed
> > several times with Linux over the years, since its behavior is not
> > defined by standards, so it's really "whatever the scheduler feels like
> > doing". The behavior is only defined with realtime scheduling
> > (SCHED_FIFO or SCHED_OTHER).
> >
> > Generally, it's a mistake to assume specific timing behavior from
> > sched_yied for SCHED_OTHER processes.
> 
> From the man sched_yield:
> 
> A  process  can  relinquish  the  processor  voluntarily without blocking by
> calling sched_yield().  The process will then be moved to the  end  of  the 
> queue  for  its static priority and a new process gets to run.
> 
> and also IEEE/Open Group:
> http://www.opengroup.org/onlinepubs/000095399/functions/sched_yield.html

Yeah, except that is for Real-Time scheduling classes, SCHED_OTHER
doesn't have static priority queues.

SCHED_OTHER doesn't have a specified implementation - so relying on it
to do anything specific is well outside the scope of definition.

