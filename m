Return-Path: <linux-kernel-owner+w=401wt.eu-S1751254AbZKZBbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbZKZBbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 20:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZKZBbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 20:31:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:37905 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750767AbZKZBbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 20:31:05 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+UA8tloNeUAyjMDOmhqZ7dx2k1wdrVWovTAc8lOz
	hfUd0CpCkZ6y/a
Subject: Re: [patch] sched: fix set_task_cpu() and provide an unlocked
 runqueue variant
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259197270.6186.17.camel@marge.simson.net>
References: <1258891781.14325.34.camel@marge.simson.net>
	 <1259173672.4027.732.camel@laptop>
	 <1259197270.6186.17.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 02:31:08 +0100
Message-Id: <1259199068.6186.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 02:01 +0100, Mike Galbraith wrote:
> On Wed, 2009-11-25 at 19:27 +0100, Peter Zijlstra wrote:

> > I've got to ask, what's that barrier for?
> 
> It's a leftover from frustrated bug hunting.

To be more specific, I put it there to ensure that min_vruntimes are
stable.  I figured that if try_to_wake_up() needs a barrier to look at
task->state, I had better do the same for the runqueues.

	-Mike

