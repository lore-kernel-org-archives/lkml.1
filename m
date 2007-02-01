Return-Path: <linux-kernel-owner+w=401wt.eu-S1161227AbXBAHKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161227AbXBAHKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 02:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161229AbXBAHKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 02:10:09 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:32900 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161227AbXBAHKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 02:10:07 -0500
Date: Thu, 1 Feb 2007 10:09:30 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Lee Revell <rlrevell@joe-job.com>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sources.redhat.com
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Message-ID: <20070201070930.GA26436@2ka.mipt.ru>
References: <20070129145227.GA10524@2ka.mipt.ru> <75b66ecd0701312028w7866c608hbf70593055c92b19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <75b66ecd0701312028w7866c608hbf70593055c92b19@mail.gmail.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Feb 2007 10:09:35 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 11:28:07PM -0500, Lee Revell (rlrevell@joe-job.com) wrote:
> On 1/29/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> >1. Scheduling fairness.
> >Since kernel does not know about multiple threads behind given process,
> >it can not add it appropriate number of timeslices for execution.
> >Can be solved either by more tight collaboarion of the userspace and
> >kernelspace schedulers or simply by increasing process' nice value.
> 
> nice value is only meaningful for SCHED_OTHER.  How will you handle a
> multithreaded realtime application that uses SCHED_OTHER as well as
> SCHED_FIFO threads?

Threads created inside one process obviously can not compete with RT
threads created by other process. Instead process, which threads have RT
priority itself should change its priority to RT to compete with other
RT process. (By RT I mean any cases except SCHED_OTHER which is
default).

> Lee

-- 
	Evgeniy Polyakov
