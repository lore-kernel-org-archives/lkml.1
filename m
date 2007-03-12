Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXCLUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXCLUmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbXCLUmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:42:53 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:15510 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932096AbXCLUmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:42:53 -0400
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1173730314.6431.30.camel@Homer.simpson.net>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703122223.07048.kernel@kolivas.org>
	 <1173710082.6326.49.camel@Homer.simpson.net>
	 <200703130549.47058.kernel@kolivas.org>
	 <1173730314.6431.30.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 21:42:37 +0100
Message-Id: <1173732157.5061.18.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 21:11 +0100, Mike Galbraith wrote:

> How would you go about ensuring that there won't be any cycles wasted?

SCHED_IDLE or otherwise nice 19
 
> Killing the known corner case starvation scenarios is wonderful, but
> let's not just pretend that interactive tasks don't have any special
> requirements.

Interaction wants low latency, getting that is traditionally expressed
in priorities - the highest prio gets the least latency (all RTOSs work
like that).

There is nothing that warrants giving them more CPU time IMHO; if you
think they deserve more, express that using priorities.

Priorities are a well understood concept and they work; heuristics can
(and Murphy tells us they will) go wrong.

Getting the server/client thing working can be done without heuristics
using class based scheduling.

