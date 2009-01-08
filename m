Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZAHIB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZAHIB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZAHIBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:01:21 -0500
Received: from viefep18-int.chello.at ([62.179.121.38]:52704 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751695AbZAHIBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:01:20 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] posix-cpu-timers: clock_gettime(CLOCK_*_CPUTIME_ID)
 goes backward
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090107175903.GF24982@elte.hu>
References: <49547320.9010302@jp.fujitsu.com> <20081226084320.GC755@elte.hu>
	 <1230282171.9487.278.camel@twins>  <20090107175903.GF24982@elte.hu>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 09:01:21 +0100
Message-Id: <1231401681.11687.389.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 18:59 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Which reminds me, why do we still have this crap in the kernel? I 
> > thought we pretty much showed the per-cpu itimer thing was utter crap? 
> > -- can we pretty please either revert that or apply 
> > http://lkml.org/lkml/2008/11/24/183 ?
> > 
> > Also, I really don't like the above, we now do the per-cpu loop with the 
> > RQ lock held...
> 
> ok, i've applied it to tip/timers/urgent. This should solve the original 
> itimer testcase as well, correct?

Yeah, but what would need to happen to make itimers not lock up large
machines is reduce its granularity depeding on machine size.

The whole (process wide) itimer idea just plain sucks -- sadly its part
of unix so we can't just drop it, the best we can do is make it useless
(but within spec) so that nobody sane will use it ;-)

