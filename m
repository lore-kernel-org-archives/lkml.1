Return-Path: <linux-kernel-owner+w=401wt.eu-S965673AbXCMJl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbXCMJl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965661AbXCMJl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:41:28 -0400
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:46424 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965673AbXCMJl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:41:27 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 20:41:05 +1100
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <200703132021.50712.kernel@kolivas.org> <20070313092920.GB7648@elte.hu>
In-Reply-To: <20070313092920.GB7648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703132041.06320.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 20:29, Ingo Molnar wrote:
> * Con Kolivas <kernel@kolivas.org> wrote:
> > Well I guess you must have missed where I asked him if he would be
> > happy if I changed +5 metrics to do whatever he wanted and he refused
> > to answer me. [...]
>
> I'd say lets keep nice levels out of this completely for now - while
> they should work _too_, it's easy because the scheduler has the 'nice'
> information. The basic behavior of CPU hogs that matters most.
>
> So the question is: if all tasks are on the same nice level, how does,
> in Mike's test scenario, RSDL behave relative to the current
> interactivity code?

If everything is run at nice 0? (this was not the test case but that's what 
you've asked for).

We have:
X + GForce contribute a load of 1
lame x 2 threads contribute a load of 2

In RSDL
X + GForce will get 33% cpu
lame will get 66% cpu

In mainline
X + GForce gets a fluctuating percentage somewhere between 35~45% as far as I 
can see on UP.
lame gets the rest

The only way to get the same behaviour on RSDL without hacking an 
interactivity estimator, priority boost cpu misproportionator onto it is to 
either -nice X or +nice lame.

> 	Ingo

-- 
-ck
