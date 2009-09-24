Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZIXPx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZIXPx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZIXPx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:53:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZIXPx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:53:58 -0400
Date: Thu, 24 Sep 2009 19:57:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] itimers: fix racy writes to cpu_itimer fields
Message-ID: <20090924195732.384bea26@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1253803687.18939.26.camel@laptop>
References: <1253802903-979-1-git-send-email-sgruszka@redhat.com>
	<1253803687.18939.26.camel@laptop>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 16:48:07 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-09-24 at 16:35 +0200, Stanislaw Gruszka wrote:
> > incr_error and error fields of struct cpu_itimer are used when calculating
> > next timer tick in check_cpu_itimers() and should not be modified without
> > tsk->sighand->siglock taken.
> 
> Won't it be all-round much better to convert these things to hrtimers
> instead of adding more and more fuzz on top to make them deal with
> jiffies?

Perhaps it would, but I don't know how to do it :{ . Especially how to
precisely account user time. The only idea I have is make something like 
microstate accounting (http://lwn.net/Articles/127296/), but this patch
and whole idea was rejected long time ago. 

Stanislaw
